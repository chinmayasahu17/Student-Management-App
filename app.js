const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const app = express();
const port = process.env.PORT || 3000;

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

// Set up Mongoose connection
mongoose.connect("mongodb://localhost:27017/studentDataDB", {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Define student schema and model
const studentSchema = new mongoose.Schema({
  name: String,
  email: String,
  roll_number: String,
  timestamp: { type: Date, default: Date.now }
});

const Student = mongoose.model("Student", studentSchema);

// Route for the root path
app.get("/", (req, res) => {
  res.render("student-forms"); // Render both forms on the root route
});

// Routes for insertion and querying
app.get("/insert", (req, res) => {
  res.render("student-forms", { mode: "insert" });
});

app.post("/insert", (req, res) => {
  // Handle form submission for data insertion
  const { name, email, roll_number } = req.body;
  const newStudent = new Student({ name, email, roll_number });
  newStudent.save();
  res.redirect("/");
});

app.get("/query", (req, res) => {
  res.render("student-forms", { mode: "query" });
});


app.post("/query", async (req, res) => {
  // Handle form submission for data querying
  const { roll_number } = req.body;
  const student = await Student.findOne({ roll_number });
  res.render("query-result", { student }); // Render the query result page
});

// Listen on the specified port
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
