# Ansible Vault
- A location where we can define variables to be used & interpolated in playbook &/or templates
```yaml
vars:
  var_path: /home/my_app
  ip_of_machine: 123.123.123.101
```

## API keys and authentication security
- Secrets
- Environment variables
- Services like ansible

What to consider:
- Is it protected from going online (.gitignore)
- Is it segregated from my code that goes onlinbe (Env variables)
- Is it encrypted (Services like ansible vault)
- How easy is it to share with colleagues? (Hashicorp Vault)

**gitignore**
- Is it protected from going online ***YES***
- Is it segregated from my code that goes online ***NO***
- Is it encrypted ***NO***)
- How easy is it to share with colleagues? ***NO***

**Environment Variables**
- Is it protected from going online ***YES***
- Is it segregated from my code that goes online ***YES***
- Is it encrypted ***NO***)
- How easy is it to share with colleagues? ***NO***
  
**Ansible Vault**
- Is it protected from going online ***YES***
- Is it segregated from my code that goes online ***YES***
- Is it encrypted ***YES***)
- How easy is it to share with colleagues? ***NO***

## Ansible Vault
- First create a directory `vault-ansible` -> cd into it and ***create the aws_keys file***: 
```yaml
ansible-vault create aws_keys.yml # -> Password -> **eng74mattwoopsy**
aws_secret_key: THISISMYSECRETKEY
aws_access_key: THISISMYACCESSKEY

esc + :wq # -> To leave vim
```

- ***Edit*** - To edit the created vault file

```yaml
ansible-vault edit aws_keys.yml
```

- ***View*** - To essentially cat the file, see whats inside
```yaml
ansible-vault view aws_keys.yml
```