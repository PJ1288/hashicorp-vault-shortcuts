# Instructions to run HashiCorp Vault in Docker

1. Check if Docker is installed on your system: 
```docker --version```

    If not installed, follow these directions:  
    For Mac: https://docs.docker.com/desktop/install/mac-install/  
    For Linux: https://docs.docker.com/desktop/install/linux-install/  
    For Windows: https://docs.docker.com/desktop/install/windows-install/  

2. Check if Docker is running:
```systemctl status docker```
Start Docker if needed:
```systemctl start docker```

3. Pull Vault's Docker image
```docker pull hashicorp/vault```

4. Run the container:
```docker run --rm -d --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -p 8200:8200 --name=dev-vault hashicorp/vault```

5. Access Vault via CLI:
    Exec into the container:
    ```docker exec -it dev-vault /bin/sh```
    Run below commands inside the container:
    ```export VAULT_ADDR=http://127.0.0.1:8200```
    ```vault status --tls-skip-verify```

6. Access Vault via the API:
```curl http://127.0.0.1:8200/v1/sys/health | jq```
