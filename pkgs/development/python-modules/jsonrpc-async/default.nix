{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  jsonrpc-base,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jsonrpc-async";
  version = "2.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-async";
    rev = version;
    hash = "sha256-KOnycsOZFDEVj8CJDwGbdtbOpMPQMVdrXbHG0fzr9PI=";
  };

  propagatedBuildInputs = [
    aiohttp
    jsonrpc-base
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "jsonrpc_async" ];

  meta = with lib; {
    description = "JSON-RPC client library for asyncio";
    homepage = "https://github.com/emlove/jsonrpc-async";
    license = licenses.bsd3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
