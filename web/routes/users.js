const express = require('express')
const router = express.Router()

/* GET users listing. */
router.get('/myusers', function (req, res, next) {
  res.send('respond with a resource')
})

module.exports = router
