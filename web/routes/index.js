const express = require('express')
const router = express.Router()

/* GET home page. Add extra comment */
router.get('/', function (req, res, next) {
  res.render('index', { title: 'Nimble-ICE' })
})

/* GET ice-flakes resource */
router.get('/ice-flakes', function (req, res, next) {
  res
    .status(201)
    .json({
      resource: 'ice-flakes',
      count: 205,
      shape: 'rectangle'
    })
})

module.exports = router
