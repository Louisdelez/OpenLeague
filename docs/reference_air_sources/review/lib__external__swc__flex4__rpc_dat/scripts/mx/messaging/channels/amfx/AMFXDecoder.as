package mx.messaging.channels.amfx
{
   import flash.net.getClassByAlias;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IExternalizable;
   import flash.utils.getDefinitionByName;
   import mx.logging.Log;
   import mx.messaging.errors.ChannelError;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.HexDecoder;
   
   [ExcludeClass]
   [ResourceBundle("messaging")]
   public class AMFXDecoder
   {
      
      private static var _resourceManager:IResourceManager;
      
      private static const SUPPORTED_VERSIONS:Array = [3];
      
      private static const REGEX_CLOSE_CDATA:RegExp = /]]&gt;/g;
      
      public function AMFXDecoder()
      {
         super();
      }
      
      private static function get resourceManager() : IResourceManager
      {
         if(!_resourceManager)
         {
            _resourceManager = ResourceManager.getInstance();
         }
         return _resourceManager;
      }
      
      private static function decodePacket(xml:XML, context:AMFXContext) : AMFXResult
      {
         var message:String = null;
         var v:String = null;
         var version:uint = 0;
         var h:XMLList = null;
         var body:XML = null;
         var result:AMFXResult = new AMFXResult();
         var name:String = xml.localName();
         if(name == "amfx")
         {
            v = xml.attribute("ver").toString();
            version = uint(v);
            if(supportedVersion(version))
            {
               h = xml.child("header");
               if(Boolean(h))
               {
                  result.headers = decodeHeaders(h,context);
               }
               body = xml.body[0];
               if(Boolean(body))
               {
                  result.result = decodeBody(body,context);
                  return result;
               }
               message = resourceManager.getString("messaging","noAMFXBody");
               throw new ChannelError(message);
            }
            message = resourceManager.getString("messaging","unsupportedAMFXVersion",[version]);
            throw new ChannelError(message);
         }
         message = resourceManager.getString("messaging","noAMFXNode");
         throw new ChannelError(message);
      }
      
      private static function decodeHeaders(xmlList:XMLList, context:AMFXContext) : Array
      {
         var h:XML = null;
         var name:String = null;
         var header:AMFXHeader = null;
         var temp:String = null;
         var children:XMLList = null;
         var headers:Array = [];
         for(var i:uint = 0; i < xmlList.length(); i++)
         {
            h = xmlList[i];
            name = h.attribute("name").toString();
            header = new AMFXHeader();
            header.name = name;
            temp = h.attribute("mustUnderstand").toString();
            header.mustUnderstand = temp == "true";
            children = h.children();
            if(children.length() > 0)
            {
               header.content = decodeValue(children[0],context);
            }
            else
            {
               header.content = null;
            }
            headers[i] = header;
         }
         return headers;
      }
      
      private static function decodeBody(xml:XML, context:AMFXContext) : Object
      {
         var result:Object = null;
         var i:uint = 0;
         var children:XMLList = xml.children();
         if(children.length() == 1)
         {
            result = decodeValue(children[0],context);
         }
         else if(children.length() > 1)
         {
            result = [];
            for(i = 0; i < children.length(); i++)
            {
               result[i] = decodeValue(children[i],context);
            }
         }
         return result;
      }
      
      public static function decodeValue(xml:XML, context:AMFXContext) : Object
      {
         var result:Object = null;
         var n:String = null;
         var i:String = null;
         var x:String = null;
         var name:String = xml.localName();
         if(name == "string")
         {
            result = decodeString(xml,context);
         }
         else if(name == "true")
         {
            result = true;
         }
         else if(name == "false")
         {
            result = false;
         }
         else if(name == "array")
         {
            result = decodeArray(xml,context);
         }
         else if(name == "object")
         {
            result = decodeObject(xml,context);
         }
         else if(name == "ref")
         {
            result = decodeRef(xml,context);
         }
         else if(name == "dictionary")
         {
            result = decodeDictionary(xml,context);
         }
         else if(name == "double")
         {
            n = xml.text().toString();
            result = Number(n);
         }
         else if(name == "int")
         {
            i = xml.text().toString();
            result = int(i);
         }
         else if(name == "null")
         {
            result = null;
         }
         else if(name == "date")
         {
            result = decodeDate(xml,context);
         }
         else if(name == "xml")
         {
            x = xml.text().toString();
            if(hasEscapedCloseCDATA(xml))
            {
               x = x.replace(REGEX_CLOSE_CDATA,"]]>");
            }
            result = new XML(x);
         }
         else if(name == "bytearray")
         {
            result = decodeByteArray(xml);
         }
         else if(name == "undefined")
         {
            result = undefined;
         }
         return result;
      }
      
      private static function decodeArray(xml:XML, context:AMFXContext) : Array
      {
         var i:uint = 0;
         var x:XML = null;
         var prop:Object = null;
         var propName:String = null;
         var array:Array = [];
         context.addObject(array);
         var entries:XMLList = xml.*;
         if(Boolean(entries))
         {
            for(i = 0; i < entries.length(); i++)
            {
               x = entries[i];
               if(x.localName() == "item")
               {
                  propName = x.attribute("name").toString();
                  prop = decodeValue(x.*[0],context);
                  array[propName] = prop;
               }
               else
               {
                  prop = decodeValue(x,context);
                  array.push(prop);
               }
            }
         }
         return array;
      }
      
      private static function decodeDictionary(xml:XML, context:AMFXContext) : Dictionary
      {
         var keyXml:XML = null;
         var valueXml:XML = null;
         var key:Object = null;
         var value:Object = null;
         var dictionary:Dictionary = new Dictionary();
         context.addObject(dictionary);
         var entries:XMLList = xml.*;
         if(entries == null)
         {
            return dictionary;
         }
         for(var i:uint = 0; i < entries.length(); i += 2)
         {
            keyXml = entries[i];
            valueXml = entries[i + 1];
            key = decodeValue(keyXml,context);
            value = decodeValue(valueXml,context);
            dictionary[key] = value;
         }
         return dictionary;
      }
      
      private static function decodeByteArray(xml:XML) : ByteArray
      {
         var str:String = xml.text().toString();
         var decoder:HexDecoder = new HexDecoder();
         decoder.decode(str);
         return decoder.drain();
      }
      
      private static function decodeDate(xml:XML, context:AMFXContext) : Date
      {
         var d:String = xml.text().toString();
         var time:Number = new Number(d);
         var result:Date = new Date();
         result.setTime(time);
         context.addObject(result);
         return result;
      }
      
      private static function decodeObject(xml:XML, context:AMFXContext) : Object
      {
         var entries:XMLList;
         var result:Object = null;
         var className:String = null;
         var classType:Class = null;
         var traits:Object = null;
         var tx:XML = null;
         var message:String = null;
         var ext:IExternalizable = null;
         var ba:ByteArray = null;
         var i:uint = 0;
         var propName:String = null;
         var propValue:* = undefined;
         className = xml.attribute("type").toString();
         if(Boolean(className))
         {
            try
            {
               classType = null;
               try
               {
                  classType = getClassByAlias(className);
               }
               catch(e1:Error)
               {
                  if(!classType)
                  {
                     classType = getDefinitionByName(className) as Class;
                  }
               }
               result = new classType();
            }
            catch(e:Error)
            {
               if(Boolean(context.log))
               {
                  context.log.warn("Error instantiating class: {0}. Reverting to anonymous Object.",className);
               }
               result = {};
            }
         }
         else
         {
            className = "Object";
            result = {};
         }
         context.addObject(result);
         entries = xml.*;
         if(Boolean(entries) && entries.length() > 0)
         {
            tx = entries[0];
            if(tx.localName() == "traits")
            {
               traits = decodeTraits(tx,className,context);
               delete entries[0];
            }
            if(!traits)
            {
               message = resourceManager.getString("messaging","AMFXTraitsNotFirst");
               throw new ChannelError(message);
            }
            if(Boolean(traits.externalizable))
            {
               if(!(result is IExternalizable))
               {
                  message = resourceManager.getString("messaging","notImplementingIExternalizable",[className]);
                  throw new ChannelError(message);
               }
               ext = IExternalizable(result);
               tx = entries[0];
               if(tx.localName() == "bytearray")
               {
                  ba = decodeByteArray(tx);
                  try
                  {
                     ext.readExternal(ba);
                  }
                  catch(e:Error)
                  {
                     message = resourceManager.getString("messaging","errorReadingIExternalizable",[e.message + e.getStackTrace()]);
                     throw new ChannelError(message);
                  }
               }
            }
            else
            {
               for(i = 0; i < entries.length(); i++)
               {
                  propName = traits.properties[i];
                  propValue = decodeValue(entries[i],context);
                  try
                  {
                     result[propName] = propValue;
                  }
                  catch(e2:Error)
                  {
                     if(context.log != null)
                     {
                        context.log.warn("Cannot set property \'{0}\' on type \'{1}\'.",propName,className);
                     }
                  }
               }
            }
         }
         return result;
      }
      
      private static function decodeRef(xml:XML, context:AMFXContext) : Object
      {
         var result:* = undefined;
         var message:String = null;
         var ref:int = 0;
         var idAttr:String = xml.attribute("id").toString();
         if(Boolean(idAttr))
         {
            ref = parseInt(idAttr);
            if(!isNaN(ref))
            {
               result = context.getObject(ref);
            }
            if(result === undefined)
            {
               message = resourceManager.getString("messaging","unknownReference",[idAttr]);
               throw new ChannelError(message);
            }
            return result;
         }
         message = resourceManager.getString("messaging","referenceMissingId");
         throw new ChannelError(message);
      }
      
      private static function decodeString(xml:XML, context:AMFXContext, isTrait:Boolean = false) : String
      {
         var str:String = null;
         var ref:uint = 0;
         var message:String = null;
         var refAttr:String = xml.attribute("id").toString();
         if(Boolean(refAttr))
         {
            ref = uint(refAttr);
            if(!isNaN(ref))
            {
               str = context.getString(ref);
            }
            if(!str)
            {
               message = resourceManager.getString("messaging","unknownStringReference",[refAttr]);
               throw new ChannelError(message);
            }
         }
         else
         {
            str = xml.text().toString();
            if(!isTrait && hasEscapedCloseCDATA(xml))
            {
               str = str.replace(REGEX_CLOSE_CDATA,"]]>");
            }
            context.addString(str);
         }
         return str;
      }
      
      private static function decodeTraits(xml:XML, className:String, context:AMFXContext) : Object
      {
         var traits:Object = null;
         var ref:uint = 0;
         var message:String = null;
         var ext:String = null;
         var nodes:XMLList = null;
         var i:uint = 0;
         var refAttr:String = xml.attribute("id").toString();
         if(Boolean(refAttr))
         {
            ref = uint(refAttr);
            if(!isNaN(ref))
            {
               traits = context.getTraitInfo(ref);
            }
            if(!traits)
            {
               message = resourceManager.getString("messaging","unknownTraitReference",[refAttr]);
               throw new ChannelError(message);
            }
         }
         else
         {
            traits = {};
            traits.name = className;
            traits.alias = className;
            traits.properties = [];
            traits.externalizable = false;
            ext = xml.attribute("externalizable").toString();
            if(ext == "true")
            {
               traits.externalizable = true;
            }
            nodes = xml.*;
            if(Boolean(nodes))
            {
               for(i = 0; i < nodes.length(); i++)
               {
                  traits.properties[i] = decodeString(nodes[i],context,true);
               }
            }
            context.addTraitInfo(traits);
         }
         return traits;
      }
      
      private static function hasEscapedCloseCDATA(xml:XML) : Boolean
      {
         var s:String = xml.toXMLString();
         if(s.indexOf("]]>") != -1)
         {
            return s.indexOf("]]&gt;") != -1;
         }
         return false;
      }
      
      private static function supportedVersion(ver:uint) : Boolean
      {
         for(var i:uint = 0; i < SUPPORTED_VERSIONS.length; i++)
         {
            if(ver == SUPPORTED_VERSIONS[i])
            {
               return true;
            }
         }
         return false;
      }
      
      public function decode(xml:XML) : AMFXResult
      {
         var context:AMFXContext = null;
         if(Boolean(xml))
         {
            context = new AMFXContext();
            context.log = Log.getLogger("mx.messaging.channels.amfx.AMFXDecoder");
            XML.ignoreWhitespace = false;
            return decodePacket(xml,context);
         }
         return null;
      }
   }
}

