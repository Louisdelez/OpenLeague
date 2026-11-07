include "flash/errors/StackOverflowError.as";
include "flash/errors/ScriptTimeoutError.as";
include "flash/errors/InvalidSWFError.as";

StackOverflowError.prototype.name = "StackOverflowError";
ScriptTimeoutError.prototype.name = "ScriptTimeoutError";
InvalidSWFError.prototype.name = "InvalidSWFError";

