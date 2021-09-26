# megalomania

## Backend setup

### Return back to the root directory
```
cd ..
```

### Set and activate a virtual enviroment
```
virtualenv venv
source venv/bin/activate
```

### Install required packages
```
pip install -r requirements.txt
```

### Run the project
```
flask run
```

### Check at `http://localhost:5000`


## Blockchain setup

Contract .sol file and its compiled version are located in 'blokchain' directory.
For setting up local blockchain server and testing contract interaction you will need Ganache and MyEtherWallet. The algorythm is described here https://proglib.io/p/smart-contract
