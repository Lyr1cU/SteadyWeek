const path = require('path');
const { getDefaultConfig } = require('expo/metro-config');
const { resolve: metroResolve } = require('metro-resolver');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

config.resolver.assetExts.push('wasm');

const defaultResolveRequest = config.resolver.resolveRequest;
config.resolver.resolveRequest = (context, moduleName, platform) => {
  const resolve = defaultResolveRequest ?? ((ctx, name, plat) => metroResolve(ctx, name, plat));
  const inExpoVectorIcons = context.originModulePath.includes(
    `${path.sep}@expo${path.sep}vector-icons${path.sep}`,
  );

  if (inExpoVectorIcons && moduleName.startsWith('./') && !path.extname(moduleName)) {
    try {
      return resolve(context, `${moduleName}.js`, platform);
    } catch {
      // fall through to default resolution
    }
  }

  return resolve(context, moduleName, platform);
};

module.exports = config;
