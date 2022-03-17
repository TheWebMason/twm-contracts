const TwmPresale = artifacts.require('TwmPresale');



module.exports = async (deployer) => {
  await deployer.deploy(TwmPresale);
};
