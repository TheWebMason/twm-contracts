const TwmPresale = artifacts.require("TwmPresale");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("TwmPresale", function (/* accounts */) {
  it("should assert true", async function () {
    await TwmPresale.deployed();
    return assert.isTrue(true);
  });
});
