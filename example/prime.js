// Example from: https://www.graalvm.org/latest/tools/code-coverage/
class AcceptFilter {
  accept() {
    return true;
  }
}
class DivisibleByFilter {
  constructor(number, next) {
    this.number = number;
    this.next = next;
  }
  accept(n) {
    var filter = this;
    while (filter != null) {
      if (n % filter.number === 0) {
        return false;
      }
      filter = filter.next;
    }
    return true;
  }
}
class Primes {
  constructor() {
    this.number = 2;
    this.filter = new AcceptFilter();
  }
  next() {
    while (!this.filter.accept(this.number)) {
      this.number++;
    }
    this.filter = new DivisibleByFilter(this.number, this.filter);
    return this.number;
  }
}
function calculatePrime(n) {
  var primes = new Primes();
  var primesArray = [];
  for (let i = 0; i < n; i++) {
    primesArray.push(primes.next());
  }
  return primesArray[n - 1];
}
function getPrime(n) {
  var cache = [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
  ];
  var n = arguments[0];
  if (n > cache.length) {
    return calculatePrime(n);
  }
  return cache[n - 1];
}
// TESTS
var tests = new Map([
  [getPrime(1), 2],
  // Make this test fail
  // [getPrime(3), 1],
  [getPrime(10), 29],
]);

const results = [];
for (const [output, expected] of tests) {
  const result = output === expected;
  console.assert(result, `Failed: ${output} !== ${expected}`);
  results.push(result);
}

const failed = results.some((i) => i === false);

if (failed) {
  quit(3);
}
