const path = require('path');

module.exports = {
  entry: './src/handlers.ts',
  target: 'node',
  mode: 'production',
  externals: {
    'aws-sdk': 'aws-sdk' // Available in Lambda runtime
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
  output: {
    libraryTarget: 'commonjs2',
    path: path.resolve(__dirname, 'dist'),
    filename: 'handlers.js',
  },
};
