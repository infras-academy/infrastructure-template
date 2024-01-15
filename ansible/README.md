# Test 
```bash
sudo apt install sshpass -y
ansible-playbook -i test-vm.ini vault.yml --user mc --ask-pass
```