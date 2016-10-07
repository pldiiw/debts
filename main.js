'use strict';
main();

function csvToJSON (csv) {
  return csv
    .split('\n')
    .map(v => {
      return v
        .split(',')
        .reduce((a, v, i) => {
          if (i === 0) {
            a.who = v;
          } else if (i === 1) {
            a.much = parseInt(v);
          } else if (i === 2) {
            a.date = v;
          } else {
            a.what = v;
          }
          return a;
        }, {})
    });
}

function cumulateSpentByUser(json, regexp) {
  return json
    .reduce((a, v) => {
      return regexp.test(v.who) ? a + v.much : a;
    }, 0);
}

function findDebtByUser(json, from_regexp, to_regexp) {
  const totalSpent = cumulateSpentByUser(json, /.*/);
  const spentByFrom = cumulateSpentByUser(json, from_regexp);
  const spentByTo = cumulateSpentByUser(json, to_regexp);
  const users = retrieveUsers(json);

  const fairShare = totalSpent / users.length;
  const fromLacking = fairShare - spentByFrom;
  const debt = fromLacking / users.length;

  return debt;
}

function retrieveUsers (json) {
    return json
      .reduce((a, v) => {
        return a.some(vs => vs === v.who) ? a : a.concat([v.who]);
      }, []);
}

function main () {
  const csv = require('fs').readFileSync('./debts.csv', 'utf8');
  const json = csvToJSON(csv).slice(1, -1);
  const users = retrieveUsers(json);
  const debts = users
    .map((v, i, arr) => {
      return {
        from: v,
        much: arr.reduce((aa, va, ia) => {
          const debt = {
            to: va,
            amount: findDebtByUser(json,
                                  (new RegExp(v)),
                                  (new RegExp(va)))
          };
          if (va == v || debt.amount <= 0) {
            return aa;
          } else {
            return aa.concat(debt);
          }
        }, [])
      }
    });
  console.log(JSON.stringify(debts, null, ' '));
 }
