const express = require("express");
const { Product } = require("../models/product");
const User = require("../models/user");
const auth = require("../middlewares/auth");
const userRouter = express.Router();

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        const { id } = req.body;
        console.log(`Request body: ${JSON.stringify(req.body)}`);

        const product = await Product.findById(id);
        console.log(`Product found: ${JSON.stringify(product)}`);

        let user = await User.findById(req.user);
        console.log(`User found: ${JSON.stringify(user)}`);

        const userId = req.user;
        console.log(`User ID: ${userId}`);

        if (user.cart.length == 0) {
            user.cart.push({ product, quantity: 1 });
            console.log(`Added product to an empty cart: ${JSON.stringify(user.cart)}`);
        } else {
            let isProductFound = false;
            for (let i = 0; i < user.cart.length; i++) {
                if (user.cart[i].product._id.equals(product._id)) {
                    isProductFound = true;
                }
            }

            if (isProductFound) {
                let producttt = user.cart.find((productt) =>
                    productt.product._id.equals(product._id)
                );
                producttt.quantity += 1;
                console.log(`Incremented quantity for an existing product: ${JSON.stringify(producttt)}`);
            } else {
                user.cart.push({ product, quantity: 1 });
                console.log(`Added a new product to the cart: ${JSON.stringify(user.cart)}`);
            }
        }
        user = await user.save();
        console.log(`User cart after saving: ${JSON.stringify(user.cart)}`);
        res.json(user);
    } catch (e) {
        console.log(`Error: ${e.message}`);
        res.status(500).json({ error: e.message });
    }
});


userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
    try {
        const { id } = req.params;
        console.log(`Product ID to remove: ${id}`);

        const product = await Product.findById(id);
        console.log(`Product found: ${JSON.stringify(product)}`);

        let user = await User.findById(req.user);
        console.log(`User found: ${JSON.stringify(user)}`);

        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(product._id)) {
                if (user.cart[i].quantity == 1) {
                    user.cart.splice(i, 1);
                    console.log(`Removed product from cart due to quantity being 1. Updated cart: ${JSON.stringify(user.cart)}`);
                } else {
                    user.cart[i].quantity -= 1;
                    console.log(`Decremented quantity for an existing product. Updated cart: ${JSON.stringify(user.cart)}`);
                }
            }
        }

        user = await user.save();
        console.log(`User cart after saving: ${JSON.stringify(user.cart)}`);
        res.json(user);
    } catch (e) {
        console.log(`Error: ${e.message}`);
        res.status(500).json({ error: e.message });
    }
});



module.exports = userRouter;