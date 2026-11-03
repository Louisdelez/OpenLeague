include "Error.as";
include "DefinitionError.as";
include "EvalError.as";
include "RangeError.as";
include "ReferenceError.as";
include "SecurityError.as";
include "SyntaxError.as";
include "TypeError.as";
include "URIError.as";
include "VerifyError.as";
include "UninitializedError.as";
include "ArgumentError.as";
include "flash/errors/IOError.as";
include "flash/errors/EOFError.as";
include "flash/errors/MemoryError.as";
include "flash/errors/IllegalOperationError.as";

IOError.prototype.name = "IOError";
MemoryError.prototype.name = "MemoryError";
EOFError.prototype.name = "EOFError";
IllegalOperationError.prototype.name = "IllegalOperationError";

