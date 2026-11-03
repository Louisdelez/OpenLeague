package org.igniterealtime.xiff.data.rpc
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class XMLRPC
   {
      
      private static var XMLFactory:XMLDocument = new XMLDocument();
      
      public function XMLRPC()
      {
         super();
      }
      
      public static function fromXML(param1:XMLNode) : Array
      {
         var _loc2_:Array = null;
         var _loc4_:XMLNode = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc3_:XMLNode = findNode("methodResponse",param1);
         if(_loc3_.firstChild.nodeName == "fault")
         {
            _loc2_ = extractValue(_loc3_.firstChild.firstChild.firstChild);
            _loc2_.isFault = true;
         }
         else
         {
            _loc2_ = new Array();
            _loc4_ = findNode("params",_loc3_);
            if(_loc4_ != null)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.childNodes.length)
               {
                  _loc6_ = _loc4_.childNodes[_loc5_].firstChild;
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.childNodes.length)
                  {
                     _loc2_.push(extractValue(_loc6_.childNodes[_loc7_]));
                     _loc7_++;
                  }
                  _loc5_++;
               }
            }
         }
         return _loc2_;
      }
      
      public static function toXML(param1:XMLNode, param2:String, param3:Array) : XMLNode
      {
         var _loc4_:XMLNode = addNode(param1,"methodCall");
         addText(addNode(_loc4_,"methodName"),param2);
         var _loc5_:XMLNode = addNode(_loc4_,"params");
         var _loc6_:int = 0;
         while(_loc6_ < param3.length)
         {
            addParameter(_loc5_,param3[_loc6_]);
            _loc6_++;
         }
         return _loc4_;
      }
      
      private static function extractValue(param1:XMLNode) : *
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:* = undefined;
         var _loc2_:* = null;
         switch(param1.nodeName)
         {
            case "int":
            case "i4":
            case "double":
               _loc2_ = Number(param1.firstChild.nodeValue);
               break;
            case "boolean":
               _loc2_ = Boolean(Number(param1.firstChild.nodeValue)) ? true : false;
               break;
            case "array":
               _loc3_ = new Array();
               _loc6_ = 0;
               while(_loc6_ < param1.firstChild.childNodes.length)
               {
                  _loc4_ = param1.firstChild.childNodes[_loc6_];
                  _loc3_.push(extractValue(_loc4_.firstChild));
                  _loc6_++;
               }
               _loc2_ = _loc3_;
               break;
            case "struct":
               _loc5_ = new Object();
               _loc7_ = 0;
               while(_loc7_ < param1.childNodes.length)
               {
                  _loc8_ = param1.childNodes[_loc7_];
                  _loc9_ = _loc8_.childNodes[0].firstChild.nodeValue;
                  _loc10_ = extractValue(_loc8_.childNodes[1].firstChild);
                  _loc5_[_loc9_] = _loc10_;
                  _loc7_++;
               }
               _loc2_ = _loc5_;
               break;
            case "dateTime.iso8601":
            case "Base64":
            case "string":
            default:
               _loc2_ = param1.firstChild.nodeValue.toString();
         }
         return _loc2_;
      }
      
      private static function addParameter(param1:XMLNode, param2:*) : XMLNode
      {
         return addValue(addNode(param1,"param"),param2);
      }
      
      private static function addValue(param1:XMLNode, param2:*) : XMLNode
      {
         var _loc4_:XMLNode = null;
         var _loc5_:int = 0;
         var _loc6_:XMLNode = null;
         var _loc7_:String = null;
         var _loc8_:XMLNode = null;
         var _loc3_:XMLNode = addNode(param1,"value");
         if(typeof param2 == "string")
         {
            addText(addNode(_loc3_,"string"),param2);
         }
         else if(typeof param2 == "number")
         {
            if(Math.floor(param2) != param2)
            {
               addText(addNode(_loc3_,"double"),param2);
            }
            else
            {
               addText(addNode(_loc3_,"int"),param2.toString());
            }
         }
         else if(typeof param2 == "boolean")
         {
            addText(addNode(_loc3_,"boolean"),param2 == false ? "0" : "1");
         }
         else if(param2 is Array)
         {
            _loc4_ = addNode(addNode(_loc3_,"array"),"data");
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               addValue(_loc4_,param2[_loc5_]);
               _loc5_++;
            }
         }
         else if(typeof param2 == "object")
         {
            if(param2.type != undefined && param2.value != undefined)
            {
               addText(addNode(_loc3_,param2.type),param2.value);
            }
            else
            {
               _loc6_ = addNode(_loc3_,"struct");
               for(_loc7_ in param2)
               {
                  _loc8_ = addNode(_loc6_,"member");
                  addText(addNode(_loc8_,"name"),_loc7_);
                  addValue(_loc8_,param2[_loc7_]);
               }
            }
         }
         return param1;
      }
      
      private static function addNode(param1:XMLNode, param2:String) : XMLNode
      {
         var _loc3_:XMLNode = XMLRPC.XMLFactory.createElement(param2);
         param1.appendChild(_loc3_);
         return param1.lastChild;
      }
      
      private static function addText(param1:XMLNode, param2:String) : XMLNode
      {
         var _loc3_:XMLNode = XMLRPC.XMLFactory.createTextNode(param2);
         param1.appendChild(_loc3_);
         return param1.lastChild;
      }
      
      private static function findNode(param1:String, param2:XMLNode) : XMLNode
      {
         var _loc3_:XMLNode = null;
         var _loc4_:String = null;
         if(param2.nodeName == param1)
         {
            return param2;
         }
         _loc3_ = null;
         for(_loc4_ in param2.childNodes)
         {
            _loc3_ = findNode(param1,param2.childNodes[_loc4_]);
            if(_loc3_ != null)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

