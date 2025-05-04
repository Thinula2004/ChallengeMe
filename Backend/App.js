const express = require("express");
const cors = require("cors");
const app = express();
const connectdb = require("./App/config/db");
const userRoutes = require("./App/routes/userRoutes");

require('dotenv').config();

// Connect to DB first
connectdb();

// Middlewares
app.use(cors());
app.use(express.json());

// Add this test route
app.get("/", (req, res) => {
    res.send("Root route working");
});

// Use routes
app.use("/api/user", userRoutes);

// Start server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Server running at: http://localhost:${PORT}`);
});
