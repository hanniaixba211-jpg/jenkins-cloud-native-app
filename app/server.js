const express = require("express");

const app = express();

const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
    res.send("Práctica 2 Jenkins Cloud Native funcionando");
});

app.get("/health", (req, res) => {
    res.json({
        status: "UP",
        service: "jenkins-cloud-native-app",
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`Servidor iniciado en el puerto ${PORT}`);
});