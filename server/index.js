const express = require("express");
const PORT = 3000;
const app = express();
const authRouter = require("./routes/auth");
const mongoose = require("mongoose");
const adminRouter = require("./routes/admin");
app.use(express.json());

app.use(authRouter);
app.use(adminRouter);

const DB = "mongodb+srv://talha:talha123@cluster0.jcrdbuk.mongodb.net/";

mongoose.connect(DB).then(() => {
    console.log("connection successfull");
}).catch((e) => {
    console.log(e);

});
// app.get("/", (req, res) => {
//     res.send({ ji: "hey talha here blank" });
// });
// app.get("/h", (req, res) => {
//     res.send({ ji: "hey talha here" });
// });
app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT} hello`);
});

