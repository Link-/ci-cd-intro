const express = require('express')
const router = express.Router()

/* GET users listing. */
router.get('/users', function (req, res, next) {
  res.send('respond with a valid resource')
})

module.exports = router
