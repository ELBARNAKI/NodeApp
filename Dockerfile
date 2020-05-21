#précision d'une image pour le build "node"
FROM node

#Définition du repétoire de travail dans lequel les prochains commandes seront exécuté
WORKDIR /opt/back

#copier le code dans l'image comme une nouvelle couche
COPY . .

#Installation des dépendances
RUN npm install

#le port d'écoute du conteneur
EXPOSE 8000

#spécification des commandes qui seront toujours exécutée au démarrage du conteneur
ENTRYPOINT ["npm", "start"]
