var fs = require("fs");
const base =
  "https://gateway.pinata.cloud/ipfs/QmX4dzq7LYLZVY5BwtKVqrdA9g6Juw8Mr5ENf6yof2kii3";

const res = [];

for (var i = 0; i <= 548; i++) {
  res.push(`${base}/${i}.json`);
}

fs.writeFile("temp.json", JSON.stringify(res), function (err) {
  if (err) {
    console.log(err);
  }
});
