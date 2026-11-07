package system.serializers.eden
{
   import system.Reflection;
   import system.Strings;
   import system.console;
   import system.text.parser.GenericParser;
   
   use namespace release;
   
   public class ECMAScript
   {
      
      private static var _globalPool:Array = [];
      
      public static var comments:String = "";
      
      private var _ORC:String = "￼";
      
      private var _1char:Boolean = false;
      
      private var _inConstructor:int;
      
      private var _localPool:Array = [];
      
      private var _source:String;
      
      public var localscope:*;
      
      private var _singleValue:Boolean = true;
      
      private var _inAssignement:Boolean = false;
      
      public var pos:uint;
      
      public var ch:String;
      
      public function ECMAScript(param1:String)
      {
         super();
         _source = param1;
         pos = 0;
         ch = "";
         localscope = {};
      }
      
      public static function evaluate(param1:String) : *
      {
         var _loc2_:ECMAScript = new ECMAScript(param1);
         return _loc2_.eval();
      }
      
      debug function traceGlobalPool#352() : void
      {
         var _loc1_:String = null;
         trace("---------------------");
         trace("global pool:");
         for(_loc1_ in _globalPool)
         {
            trace(_loc1_ + " = " + _globalPool[_loc1_]);
         }
         trace("---------------------");
      }
      
      public function hasMoreChar() : Boolean
      {
         return pos <= source.length - 1;
      }
      
      public function isIdentifierPart(param1:String) : Boolean
      {
         release::debug#353("isIdentifierPart( \"" + param1 + "\" )");
         if(isIdentifierStart(param1))
         {
            return true;
         }
         if(GenericParser.isDigit(param1))
         {
            return true;
         }
         if(param1.charCodeAt(0) < 128)
         {
            return false;
         }
         return false;
      }
      
      release function traceGlobalPool#353() : void
      {
      }
      
      private function _scanString(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         release::debug#353("scanString( " + param1 + " )");
         var _loc2_:String = "";
         if(ch == param1)
         {
            while(next() != "")
            {
               switch(ch)
               {
                  case param1:
                     next();
                     return _loc2_;
                  case "\\":
                     switch(next())
                     {
                        case "b":
                           _loc2_ += "\b";
                           break;
                        case "t":
                           _loc2_ += "\t";
                           break;
                        case "n":
                           _loc2_ += "\n";
                           break;
                        case "v":
                           _loc2_ += "\x0b";
                           break;
                        case "f":
                           _loc2_ += "\f";
                           break;
                        case "r":
                           _loc2_ += "\r";
                           break;
                        case "\"":
                           _loc2_ += "\"";
                           break;
                        case "\'":
                           _loc2_ += "\'";
                           break;
                        case "\\":
                           _loc2_ += "\\";
                           break;
                        case "u":
                           _loc3_ = source.substring(pos,pos + 4);
                           _loc2_ += String.fromCharCode(parseInt(_loc3_,16));
                           pos += 4;
                           break;
                        case "x":
                           _loc4_ = source.substring(pos,pos + 2);
                           _loc2_ += String.fromCharCode(parseInt(_loc4_,16));
                           pos += 2;
                           break;
                        default:
                           _loc2_ += ch;
                     }
                     break;
                  default:
                     if(!isLineTerminator(ch))
                     {
                        _loc2_ += ch;
                     }
                     else
                     {
                        log(strings.errorLineTerminator);
                     }
               }
            }
         }
         log(strings.errorString);
         return "";
      }
      
      private function _scanGlobalAssignement(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         release::debug#353("scanGlobalAssignement( " + param1 + " )");
         var _loc3_:String = "";
         var _loc4_:* = "";
         var _loc5_:Array = _pathAsArray(param1);
         var _loc6_:String = _loc5_.pop();
         var _loc7_:Boolean = false;
         var _loc8_:int = int(_loc5_.length);
         while(_loc9_ < _loc8_)
         {
            if(!_loc7_)
            {
               if(_loc9_ == 0)
               {
                  _loc3_ = _loc5_[_loc9_];
               }
               else
               {
                  _loc3_ += "." + _loc5_[_loc9_];
               }
               if(Reflection.hasClassByName(_loc3_))
               {
                  _loc7_ = true;
                  _loc2_ = Reflection.getDefinitionByName(_loc3_);
               }
            }
            else
            {
               _loc4_ = _loc5_[_loc9_];
               if(isDigitNumber(_loc4_))
               {
                  _loc4_ = parseInt(_loc4_);
               }
               if(_loc2_[_loc4_] == undefined)
               {
                  return;
               }
               _loc2_ = _loc2_[_loc4_];
            }
            _loc9_++;
         }
         _scanWhiteSpace();
         if(ch == "=")
         {
            _singleValue = false;
            _inAssignement = true;
            next();
            _scanWhiteSpace();
            if(isLineTerminator(ch))
            {
               log("assignement = without RHS !");
               return;
            }
            _loc10_ = _scanValue();
            _loc2_[_loc6_] = _loc10_;
            _globalPool[param1] = _loc2_[_loc6_];
            _inAssignement = false;
         }
      }
      
      public function isReservedKeyword(param1:String) : Boolean
      {
         release::debug#353("isReservedKeyword( \"" + param1 + "\" )");
         if(!config.strictMode)
         {
            param1 = param1.toLowerCase();
         }
         switch(param1)
         {
            case "break":
            case "case":
            case "catch":
            case "continue":
            case "default":
            case "delete":
            case "do":
            case "else":
            case "finally":
            case "for":
            case "function":
            case "if":
            case "in":
            case "instanceof":
            case "new":
            case "return":
            case "switch":
            case "this":
            case "throw":
            case "try":
            case "typeof":
            case "var":
            case "void":
            case "while":
            case "with":
               log(Strings.format(strings.reservedKeyword,param1));
               return true;
            default:
               return false;
         }
      }
      
      debug function tracePool#352() : void
      {
         var _loc1_:String = null;
         trace("---------------------");
         trace("local pool:");
         for(_loc1_ in _localPool)
         {
            trace(_loc1_);
         }
         trace("---------------------");
      }
      
      public function get source() : String
      {
         return _source;
      }
      
      public function eval() : *
      {
         var _loc2_:* = undefined;
         release::debug#353("eval()");
         comments = "";
         var _loc1_:* = _ORC;
         if(source.length == 1)
         {
            _1char = true;
         }
         while(hasMoreChar())
         {
            _scanSeparators();
            if(!GenericParser.isAlpha(ch))
            {
               next();
            }
            _loc2_ = _scanValue();
            _scanSeparators();
            if(_loc2_ != _ORC)
            {
               _loc1_ = _loc2_;
            }
            if(ch == " ")
            {
               ch = ";";
            }
         }
         if(_loc1_ == _ORC)
         {
            _loc1_ = undefined;
         }
         if(!_singleValue)
         {
            _loc1_ = localscope;
         }
         return _loc1_;
      }
      
      public function getCharAt(param1:uint) : String
      {
         return source.charAt(param1);
      }
      
      private function _scanPath() : String
      {
         release::debug#353("scanPath()");
         var _loc1_:String = "";
         var _loc2_:String = "";
         if(isIdentifierStart(ch))
         {
            _loc1_ += ch;
            next();
            while(isIdentifierPart(ch) || ch == "." || ch == "[")
            {
               if(ch == "[")
               {
                  next();
                  _scanWhiteSpace();
                  if(GenericParser.isDigit(ch))
                  {
                     _loc2_ = String(_scanNumber());
                     _scanWhiteSpace();
                     _loc1_ += "." + _loc2_;
                  }
                  else if(this.ch == "\"" || this.ch == "\'")
                  {
                     _loc2_ = _scanString(ch);
                     _scanWhiteSpace();
                     _loc1_ += "." + _loc2_;
                  }
                  if(ch == "]")
                  {
                     next();
                     continue;
                  }
               }
               _loc1_ += ch;
               next();
            }
         }
         release::debug#353("scanPath returns [" + _loc1_ + "]");
         return _loc1_;
      }
      
      release function tracePool#353() : void
      {
      }
      
      private function _scanIdentifier() : String
      {
         release::debug#353("scanIdentifier()");
         var _loc1_:String = "";
         if(isIdentifierStart(ch))
         {
            _loc1_ += ch;
            next();
            while(isIdentifierPart(ch))
            {
               _loc1_ += ch;
               next();
            }
         }
         else
         {
            log(strings.errorIdentifier);
         }
         return _loc1_;
      }
      
      private function _scanSeparators() : void
      {
         release::debug#353("scanSeparators()");
         var _loc1_:Boolean = true;
         while(_loc1_)
         {
            switch(ch)
            {
               case "\t":
               case "\x0b":
               case "\f":
               case " ":
               case " ":
                  next();
                  break;
               case "\n":
               case "\r":
               case " ":
               case " ":
                  next();
                  break;
               case "/":
                  _scanComments();
                  break;
               default:
                  _loc1_ = false;
            }
         }
      }
      
      private function _pathAsArray(param1:String) : Array
      {
         var _loc2_:Array = null;
         release::debug#353("_pathAsArray( \"" + param1 + "\" )");
         if(param1.indexOf(".") > -1)
         {
            _loc2_ = param1.split(".");
         }
         else
         {
            _loc2_ = [param1];
         }
         release::debug#353("_pathAsArray returns [" + param1 + "]");
         return _loc2_;
      }
      
      public function isIdentifierStart(param1:String) : Boolean
      {
         release::debug#353("isIdentifierStart( \"" + param1 + "\" )");
         if(GenericParser.isAlpha(param1) || param1 == "_" || param1 == "$")
         {
            return true;
         }
         if(param1.charCodeAt(0) < 128)
         {
            return false;
         }
         return false;
      }
      
      public function isValidPath(param1:String) : Boolean
      {
         var _loc3_:String = null;
         release::debug#353("isValidPath( \"" + param1 + "\" )");
         var _loc2_:Array = _pathAsArray(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(isReservedKeyword(_loc3_) || isFutureReservedKeyword(_loc3_))
            {
               log(Strings.format(strings.notValidPath,param1));
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      private function _scanObject() : Object
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         release::debug#353("scanObject()");
         var _loc1_:Object = {};
         if(ch == "{")
         {
            next();
            _scanSeparators();
            if(ch == "}")
            {
               next();
               return _loc1_;
            }
            while(ch != "")
            {
               _loc2_ = _scanIdentifier();
               _scanWhiteSpace();
               if(ch != ":")
               {
                  break;
               }
               next();
               _inAssignement = true;
               _loc3_ = _scanValue();
               _inAssignement = false;
               if(!isReservedKeyword(_loc2_) && !isFutureReservedKeyword(_loc2_))
               {
                  _loc1_[_loc2_] = _loc3_;
               }
               _scanSeparators();
               if(ch == "}")
               {
                  next();
                  return _loc1_;
               }
               if(ch != ",")
               {
                  break;
               }
               next();
               _scanSeparators();
            }
         }
         log(strings.errorObject);
         return undefined;
      }
      
      public function log(param1:String) : void
      {
         if(config.verbose)
         {
            trace(param1);
         }
      }
      
      protected function trace(param1:String) : void
      {
         console.writeLine(param1);
      }
      
      private function _scanRootLocalAssignement(param1:String) : void
      {
         var _loc2_:* = undefined;
         release::debug#353("scanRootLocalAssignement( " + param1 + " )");
         _scanWhiteSpace();
         if(ch == "=")
         {
            _singleValue = false;
            _inAssignement = true;
            next();
            _scanSeparators();
            if(isLineTerminator(ch))
            {
               log("assignement = without RHS !");
               return;
            }
            _loc2_ = _scanValue();
            if(_loc2_ == _ORC)
            {
               _loc2_ = config.undefineable;
            }
            localscope[param1] = _loc2_;
            _localPool[param1] = localscope[param1];
            release::tracePool#353();
            _inAssignement = false;
         }
      }
      
      public function getChar() : String
      {
         return source.charAt(pos);
      }
      
      private function _doesExistInLocalScope(param1:String) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         release::debug#353("doesExistInLocalScope( \"" + param1 + "\" )");
         if(_localPool[param1] != undefined)
         {
            return true;
         }
         var _loc2_:* = localscope;
         var _loc3_:Array = _pathAsArray(param1);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc5_ = false;
            _loc4_ = _loc3_[_loc6_];
            if(isDigitNumber(_loc4_))
            {
               _loc4_ = parseInt(_loc4_);
               _loc5_ = true;
            }
            if(_loc2_[_loc4_] == undefined)
            {
               return false;
            }
            if(_loc5_)
            {
               _localPool[_loc3_.slice(0,_loc6_).join(".") + "." + _loc4_] = _loc2_[_loc4_];
            }
            _loc2_ = _loc2_[_loc4_];
            _loc6_++;
         }
         return true;
      }
      
      debug function debug#352(param1:String) : void
      {
         trace(param1);
      }
      
      public function isFutureReservedKeyword(param1:String) : Boolean
      {
         release::debug#353("isFutureReservedKeyword( \"" + param1 + "\" )");
         if(!config.strictMode)
         {
            param1 = param1.toLowerCase();
         }
         switch(param1)
         {
            case "abstract":
            case "boolean":
            case "byte":
            case "char":
            case "class":
            case "const":
            case "debugger":
            case "double":
            case "enum":
            case "export":
            case "extends":
            case "final":
            case "float":
            case "goto":
            case "implements":
            case "import":
            case "int":
            case "interface":
            case "long":
            case "native":
            case "package":
            case "private":
            case "protected":
            case "public":
            case "short":
            case "static":
            case "super":
            case "synchronized":
            case "throws":
            case "transient":
            case "volatile":
               log(Strings.format(strings.futurReservedKeyword,param1));
               return true;
            default:
               return false;
         }
      }
      
      private function _scanWhiteSpace() : void
      {
         release::debug#353("scanWhiteSpace()");
         var _loc1_:Boolean = true;
         while(_loc1_)
         {
            switch(ch)
            {
               case "\t":
               case "\x0b":
               case "\f":
               case " ":
               case " ":
                  next();
                  break;
               case "/":
                  _scanComments();
                  break;
               default:
                  _loc1_ = false;
            }
         }
      }
      
      release function debug#353(param1:String) : void
      {
      }
      
      private function _doesExistInGlobalScope(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc6_:Boolean = false;
         release::debug#353("doesExistInGlobalScope( \"" + param1 + "\" )");
         if(_globalPool[param1] != undefined)
         {
            release::traceGlobalPool#353();
            return true;
         }
         if(param1.indexOf(".") == -1)
         {
            switch(param1)
            {
               case "decodeURI":
                  _globalPool[param1] = decodeURI;
                  return true;
               case "decodeURIComponent":
                  _globalPool[param1] = decodeURIComponent;
                  return true;
               case "encodeURI":
                  _globalPool[param1] = encodeURI;
                  return true;
               case "encodeURIComponent":
                  _globalPool[param1] = encodeURIComponent;
                  return true;
               case "isNaN":
                  _globalPool[param1] = isNaN;
                  return true;
               case "isFinite":
                  _globalPool[param1] = isFinite;
                  return true;
               case "parseInt":
                  _globalPool[param1] = parseInt;
                  return true;
               case "parseFloat":
                  _globalPool[param1] = parseFloat;
                  return true;
               case "escape":
                  _globalPool[param1] = escape;
                  return true;
               case "unescape":
                  _globalPool[param1] = unescape;
                  return true;
               case "isXMLName":
                  _globalPool[param1] = isXMLName;
                  return true;
            }
         }
         var _loc3_:String = "";
         var _loc4_:* = "";
         var _loc5_:Array = _pathAsArray(param1);
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_.length)
         {
            if(!_loc7_)
            {
               if(_loc8_ == 0)
               {
                  _loc3_ = _loc5_[_loc8_];
               }
               else
               {
                  _loc3_ += "." + _loc5_[_loc8_];
               }
               if(_globalPool[_loc3_] != undefined)
               {
                  _loc7_ = true;
                  _loc2_ = _globalPool[_loc3_];
               }
               else if(Reflection.hasClassByName(_loc3_))
               {
                  _loc7_ = true;
                  _loc2_ = Reflection.getDefinitionByName(_loc3_);
                  release::debug#353("GLOBAL POOL: " + _loc3_);
                  _globalPool[_loc3_] = _loc2_;
               }
            }
            else
            {
               _loc6_ = false;
               _loc4_ = _loc5_[_loc8_];
               if(isDigitNumber(_loc4_))
               {
                  _loc4_ = parseInt(_loc4_);
                  _loc6_ = true;
               }
               if(_loc2_[_loc4_] == undefined)
               {
                  return false;
               }
               if(_loc6_)
               {
                  release::debug#353(">> GLOBAL POOL : " + _loc3_ + "." + _loc5_[_loc8_ - 1] + "." + _loc4_);
                  _globalPool[_loc3_ + "." + _loc5_[_loc8_ - 1] + "." + _loc4_] = _loc2_[_loc4_];
               }
               else
               {
                  release::debug#353(">> GLOBAL POOL : " + _loc3_ + "." + _loc4_);
                  _globalPool[_loc3_ + "." + _loc4_] = _loc2_[_loc4_];
               }
               _loc2_ = _loc2_[_loc4_];
            }
            _loc8_++;
         }
         if(_loc7_)
         {
            return true;
         }
         return false;
      }
      
      public function isLineTerminator(param1:String) : Boolean
      {
         release::debug#353("isLineTerminator( \"" + param1 + "\" )");
         switch(param1)
         {
            case "\n":
            case "\r":
            case " ":
            case " ":
               return true;
            default:
               return false;
         }
      }
      
      private function _createPath(param1:String) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         release::debug#353("_createPath( \"" + param1 + "\" )");
         var _loc2_:Array = _pathAsArray(param1);
         var _loc3_:* = _loc2_.shift();
         var _loc4_:String = "";
         if(localscope[_loc3_] == undefined)
         {
            if(isDigitNumber(_loc3_))
            {
               _loc3_ = parseInt(_loc3_);
            }
            localscope[_loc3_] = {};
            _localPool[_loc3_] = localscope[_loc3_];
         }
         if(_loc2_.length > 0)
         {
            _loc4_ = _loc3_;
            _loc6_ = localscope[_loc3_];
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               _loc5_ = _loc2_[_loc7_];
               _loc4_ += "." + _loc5_;
               if(isDigitNumber(_loc5_))
               {
                  _loc5_ = parseInt(_loc5_);
               }
               if(_loc6_[_loc5_] == undefined)
               {
                  _loc6_[_loc5_] = {};
                  _localPool[_loc4_] = _loc6_[_loc5_];
               }
               _loc6_ = _loc6_[_loc5_];
               _loc7_++;
            }
         }
      }
      
      private function _scanFunction(param1:String, param2:*, param3:* = null) : *
      {
         var foundEndParenthesis:Boolean;
         var isClass:Boolean;
         var args:Array;
         var fcnName:String = null;
         var fcnObj:* = undefined;
         var fcnObjScope:* = undefined;
         var result:* = undefined;
         var fcnPath:String = param1;
         var pool:* = param2;
         var ref:* = param3;
         release::debug#353("scanFunction( " + fcnPath + " )");
         args = [];
         isClass = pool[fcnPath] is Class;
         if(fcnPath.indexOf(".") > -1)
         {
            fcnName = fcnPath.split(".").pop();
         }
         else
         {
            fcnName = fcnPath;
         }
         if(!isClass)
         {
            fcnPath = fcnPath.split("." + fcnName).join("");
         }
         _scanWhiteSpace();
         next();
         _scanSeparators();
         foundEndParenthesis = false;
         while(ch != "")
         {
            if(ch == ")")
            {
               foundEndParenthesis = true;
               next();
               break;
            }
            args.push(_scanValue());
            _scanSeparators();
            if(ch == ",")
            {
               next();
               _scanSeparators();
            }
            if(pos == source.length && ch != ")")
            {
               log("unterminated parenthesis, check your function/constructor \"" + fcnPath + "\"");
               return config.undefineable;
            }
         }
         if(!foundEndParenthesis)
         {
            log("unterminated parenthesis, check your function/constructor \"" + fcnPath + "\"");
            return config.undefineable;
         }
         if(isClass || fcnPath == fcnName)
         {
            fcnObj = pool[fcnPath];
            fcnObjScope = null;
         }
         else
         {
            fcnObj = pool[fcnPath][fcnName];
            fcnObjScope = pool[fcnPath];
         }
         if(!isClass && ref == null && fcnObj == undefined)
         {
            log(Strings.format(strings.doesNotExist,fcnPath));
            return config.undefineable;
         }
         if(_inConstructor <= 0)
         {
            if(ref != null)
            {
               result = ref[fcnName].apply(ref,args);
            }
            else
            {
               result = fcnObj.apply(fcnObjScope,args);
            }
            if(ch == ".")
            {
               next();
               return _scanFunction(_scanPath(),pool,result);
            }
            if(!config.allowFunctionCall)
            {
               log(Strings.format(strings.notFunctionCallAllowed,fcnPath,args));
               return config.undefineable;
            }
            return result;
         }
         --_inConstructor;
         try
         {
            return Reflection.invokeClass(fcnObj as Class,args);
         }
         catch(e:Error)
         {
            log("malformed ctor - " + e.toString());
            return config.undefineable;
         }
      }
      
      public function isDigitNumber(param1:String) : Boolean
      {
         release::debug#353("isDigitNumber( \"" + param1 + "\" )");
         var _loc2_:Array = param1.split("");
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!GenericParser.isDigit(_loc2_[_loc3_]))
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function _scanNumber() : Number
      {
         var _loc1_:Number = NaN;
         release::debug#353("scanNumber()");
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         if(ch == "-")
         {
            _loc4_ = "-";
            next();
         }
         if(ch == "0")
         {
            next();
            if(ch == "x" || ch == "X")
            {
               next();
               while(GenericParser.isHexDigit(ch))
               {
                  _loc3_ += ch;
                  next();
               }
               if(_loc3_ == "")
               {
                  log(strings.malformedHexadecimal);
                  return NaN;
               }
               return Number(_loc4_ + "0x" + _loc3_);
            }
            _loc2_ += "0";
         }
         while(GenericParser.isDigit(ch))
         {
            _loc2_ += ch;
            next();
         }
         if(ch == ".")
         {
            _loc2_ += ".";
            next();
            while(GenericParser.isDigit(ch))
            {
               _loc2_ += ch;
               next();
            }
         }
         if(ch == "e")
         {
            _loc2_ += "e";
            _loc5_ = next();
            if(_loc5_ == "+" || _loc5_ == "-")
            {
               _loc2_ += _loc5_;
               next();
            }
            while(GenericParser.isDigit(ch))
            {
               _loc2_ += ch;
               next();
            }
         }
         _loc1_ = Number(_loc4_ + _loc2_);
         if(!isFinite(_loc1_))
         {
            log(strings.errorNumber);
            return NaN;
         }
         return _loc1_;
      }
      
      private function _scanArray() : Array
      {
         release::debug#353("scanArray()");
         var _loc1_:Array = [];
         if(ch == "[")
         {
            next();
            _scanSeparators();
            if(ch == "]")
            {
               next();
               return _loc1_;
            }
            while(ch != "")
            {
               _loc1_.push(_scanValue());
               _scanSeparators();
               if(ch == "]")
               {
                  next();
                  return _loc1_;
               }
               if(ch != ",")
               {
                  break;
               }
               next();
               _scanSeparators();
            }
         }
         log(strings.errorArray);
         return undefined;
      }
      
      private function _scanKeyword(param1:String = "") : *
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         release::debug#353("scanKeyword( " + param1 + " )");
         var _loc2_:String = "";
         var _loc3_:String = _scanPath();
         _loc2_ = param1 + _loc3_;
         if(_loc2_ == "")
         {
            return _ORC;
         }
         switch(_loc2_)
         {
            case "undefined":
               return config.undefineable;
            case "null":
               return null;
            case "true":
               return true;
            case "false":
               return false;
            case "NaN":
               return NaN;
            case "-Infinity":
               return -Infinity;
            case "Infinity":
            case "+Infinity":
               return Infinity;
            case "new":
               ++_inConstructor;
               _scanWhiteSpace();
               _loc3_ = _scanPath();
         }
         _loc4_ = false;
         _loc5_ = false;
         if(_doesExistInGlobalScope(_loc3_))
         {
            _loc5_ = true;
         }
         else if(_doesExistInLocalScope(_loc3_))
         {
            _loc4_ = true;
            _singleValue = false;
         }
         else if(isValidPath(_loc3_) && !_inAssignement && !_inConstructor)
         {
            _createPath(_loc3_);
            _loc4_ = true;
            _singleValue = false;
         }
         if(!_inAssignement && source.indexOf("=") > -1)
         {
            if(_loc4_)
            {
               _scanLocalAssignement(_loc3_);
            }
            else if(_loc5_)
            {
               _scanGlobalAssignement(_loc3_);
            }
         }
         if(!_loc4_ && !_loc5_)
         {
            log(_loc3_ + " not found in MEMORY!");
            return config.undefineable;
         }
         if(_loc4_)
         {
            if(ch == "(")
            {
               _loc6_ = _scanFunction(_loc3_,_localPool);
            }
            else
            {
               _loc6_ = _localPool[_loc3_];
            }
            return param1 == "-" ? -_loc6_ : _loc6_;
         }
         if(_loc5_)
         {
            if(ch == "(")
            {
               _loc6_ = _scanFunction(_loc3_,_globalPool);
            }
            else
            {
               _loc6_ = _globalPool[_loc3_];
            }
            return param1 == "-" ? -_loc6_ : _loc6_;
         }
         return config.undefineable;
      }
      
      private function _scanComments() : void
      {
         var _loc1_:String = null;
         release::debug#353("scanComments()");
         next();
         switch(ch)
         {
            case "/":
               comments += "//";
               while(!isLineTerminator(ch) && hasMoreChar())
               {
                  next();
                  comments += ch;
               }
               _scanSeparators();
               break;
            case "*":
               comments += "/*";
               _loc1_ = next();
               comments += _loc1_;
               while(_loc1_ != "*" && ch != "/")
               {
                  _loc1_ = ch;
                  next();
                  comments += ch;
                  if(ch == "")
                  {
                     log(strings.unterminatedComment);
                     break;
                  }
               }
               next();
               break;
            case "":
            default:
               log(strings.errorComment);
         }
      }
      
      private function _scanLocalAssignement(param1:String) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         release::debug#353("scanLocalAssignement( " + param1 + " )");
         if(param1.indexOf(".") == -1)
         {
            _scanRootLocalAssignement(param1);
            return;
         }
         var _loc2_:Array = _pathAsArray(param1);
         var _loc3_:* = _loc2_.shift();
         var _loc4_:* = _loc2_.pop();
         if(isDigitNumber(_loc3_))
         {
            _loc3_ = parseInt(_loc3_);
         }
         if(isDigitNumber(_loc4_))
         {
            _loc4_ = parseInt(_loc4_);
         }
         _loc6_ = localscope[_loc3_];
         var _loc7_:int = int(_loc2_.length);
         while(_loc8_ < _loc7_)
         {
            _loc5_ = _loc2_[_loc8_];
            if(isDigitNumber(_loc5_))
            {
               _loc5_ = parseInt(_loc5_);
            }
            if(_loc6_[_loc5_] == undefined)
            {
               return;
            }
            _loc6_ = _loc6_[_loc5_];
            _loc8_++;
         }
         _scanWhiteSpace();
         if(ch == "=")
         {
            _singleValue = false;
            _inAssignement = true;
            next();
            _scanSeparators();
            if(isLineTerminator(ch))
            {
               log("assignement = without RHS !");
               return;
            }
            _loc9_ = _scanValue();
            _loc6_[_loc4_] = _loc9_;
            _localPool[param1] = _loc6_[_loc4_];
            release::tracePool#353();
            _inAssignement = false;
         }
      }
      
      public function next() : String
      {
         ch = getChar();
         ++pos;
         return ch;
      }
      
      private function _scanValue() : *
      {
         var _loc1_:String = null;
         release::debug#353("scanValue() - ch:" + ch);
         _scanSeparators();
         release::debug#353("after scan - ch:" + ch);
         if(pos == source.length && !_1char)
         {
            release::debug#353("prevent unecessary scan");
            if(_inAssignement)
            {
               release::debug#353("RHS is missing");
            }
            return;
         }
         switch(ch)
         {
            case "{":
               return _scanObject();
            case "[":
               return _scanArray();
            case "\"":
            case "\'":
               return _scanString(ch);
            case "-":
            case "+":
               if(GenericParser.isDigit(source.charAt(pos)))
               {
                  return _scanNumber();
               }
               _loc1_ = ch;
               next();
               return _scanKeyword(_loc1_);
               break;
            case "0":
            case "1":
            case "2":
            case "3":
            case "4":
            case "5":
            case "6":
            case "7":
            case "8":
            case "9":
               return _scanNumber();
            default:
               return _scanKeyword();
         }
      }
   }
}

