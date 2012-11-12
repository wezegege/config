read -p "User uid: " user
stty -echo
read -p "New password: " new; echo
read -p "Confirm password: " besure; echo
stty echo
[[ ${new} != ${besure} ]] && echo "Password do not match" && exit 1
hashed=`slappasswd -h '{SSHA}' -s ${new} -v`
ldapmodify -h ldap-local -x -D "cn=Manager,dc=scom,dc=sagem" -W -c << EOF
dn: uid=${user},ou=people,dc=scom,dc=sagem
changetype: modify
delete: userPassword
-
add: userPassword
userPassword: ${hashed}
EOF
