@echo OFF

set code_sign_tool_path=%CODE_SIGN_TOOL_PATH%

if defined code_sign_tool_path (
%code_sign_tool_path%\jdk-11.0.2\bin\java -jar %code_sign_tool_path%\jar\code_sign_tool-1.3.0.jar %*
) else (
.\jdk-11.0.2\bin\java -jar .\jar\code_sign_tool-1.3.0.jar %*
)