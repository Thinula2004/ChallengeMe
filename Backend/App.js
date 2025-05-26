const express = require("express");
const cors = require("cors");
const app = express();
const connectdb = require("./App/config/db");
const userRoutes = require("./App/routes/userRoutes");
const challengeRoutes = require("./App/routes/challengeRoutes");
const messageRoutes = require("./App/routes/messageRoutes");

require('dotenv').config();

connectdb();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.send("Root route working");
});

app.use("/api/user", userRoutes);
app.use("/api/challenge", challengeRoutes)
app.use("/api/message", messageRoutes)

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Server running at: http://localhost:${PORT}`);
});
