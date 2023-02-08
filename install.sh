#!/bin/bash

echo "Welcome to Plasmmer SharedChain installer!"

echo "- Copying (probably) a lot of files. Don't worry if it takes several times..."
sudo mkdir /usr/lib/sharedchain
sudo cp -r -f --preserve=all . /usr/lib/sharedchain

echo "- Installing Plasmmer SharedChain in /usr/bin..."
sudo cat > /usr/bin/sharedchain << ENDOFFILE
#!/bin/bash

source /usr/lib/sharedchain/sharedchain
ENDOFFILE

echo "- Turning Plasmmer SharedChain into an executable..."
chmod 755 /usr/bin/sharedchain && sudo chmod +x /usr/bin/sharedchain

sudo rm /usr/lib/sharedchain/install.sh # no need anymore to use the installer again

echo "Done!"
