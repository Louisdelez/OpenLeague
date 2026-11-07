package mx.messaging.channels.amfx
{
   import flash.utils.ByteArray;
   import flash.utils.IExternalizable;
   import flash.utils.describeType;
   import flash.xml.XMLDocument;
   import mx.logging.Log;
   import mx.utils.HexEncoder;
   import mx.utils.ObjectProxy;
   import mx.utils.ObjectUtil;
   
   [ExcludeClass]
   public class AMFXEncoder
   {
      
      public static const CURRENT_VERSION:uint = 3;
      
      public static const NAMESPACE_URI:String = "http://www.macromedia.com/2005/amfx";
      
      public static const NAMESPACE:Namespace = new Namespace("",NAMESPACE_URI);
      
      private static const REGEX_CLASSNAME:RegExp = /\:\:/g;
      
      private static const REGEX_CLOSE_CDATA:RegExp = /]]>/g;
      
      private static const CLASS_INFO_OPTIONS:Object = {
         "includeReadOnly":false,
         "includeTransient":false
      };
      
      private static const X_FALSE:XML = <false/>;
      
      private static const X_NULL:XML = <null/>;
      
      private static const X_TRUE:XML = <true/>;
      
      private static const X_UNDEFINED:XML = <undefined/>;
      
      private var settings:Object;
      
      public function AMFXEncoder()
      {
         super();
         settings = {};
         settings.prettyPrinting = false;
      }
      
      private static function encodeByteArray(xml:XML, obj:ByteArray) : void
      {
         var element:XML = <bytearray/>;
         var encoder:HexEncoder = new HexEncoder();
         encoder.encode(obj);
         var encoded:String = encoder.flush();
         element.appendChild(encoded);
         xml.appendChild(element);
      }
      
      private static function encodeString(xml:XML, str:String, context:AMFXContext, isTrait:Boolean = false) : void
      {
         var x:XML = null;
         var ref:int = context.findString(str);
         var element:XML = <string/>;
         if(ref >= 0)
         {
            element["id"] = String(ref);
         }
         else
         {
            context.addString(str);
            if(str.length > 0)
            {
               if(!isTrait)
               {
                  str = escapeXMLString(str);
               }
               x = new XML(str);
               element.appendChild(x);
            }
         }
         xml.appendChild(element);
      }
      
      private static function escapeXMLString(str:String) : String
      {
         if(str.length > 0)
         {
            if(str.indexOf("<") != -1 || str.indexOf("&") != -1)
            {
               if(str.indexOf("]]>") != -1)
               {
                  str = str.replace(REGEX_CLOSE_CDATA,"]]&gt;");
               }
               str = "<![CDATA[" + str + "]]>";
            }
         }
         return str;
      }
      
      private static function encodeHeaders(xml:XML, headers:Array, context:AMFXContext) : void
      {
         var header:Object = null;
         var element:XML = null;
         for(var i:uint = 0; i < headers.length; i++)
         {
            header = headers[i];
            element = <header/>;
            element["name"] = header.name;
            element["mustUnderstand"] = header.mustUnderstand == true;
            encodeValue(element,header.content,context);
            xml.appendChild(element);
         }
      }
      
      private static function encodeBody(xml:XML, obj:*, context:AMFXContext) : void
      {
         var element:XML = <body/>;
         encodeValue(element,obj,context);
         xml.appendChild(element);
      }
      
      private static function encodeTraits(xml:XML, classInfo:Object, context:AMFXContext) : void
      {
         var properties:Array = null;
         var count:uint = 0;
         var i:uint = 0;
         var prop:String = null;
         var element:XML = <traits/>;
         var ref:int = context.findTraitInfo(classInfo);
         if(ref >= 0)
         {
            element["id"] = String(ref);
         }
         else
         {
            context.addTraitInfo(classInfo);
            if(Boolean(classInfo.externalizable))
            {
               element["externalizable"] = "true";
            }
            else
            {
               properties = classInfo.properties;
               if(properties != null)
               {
                  count = properties.length;
                  for(i = 0; i < count; i++)
                  {
                     prop = properties[i];
                     encodeString(element,prop,context,true);
                  }
               }
            }
         }
         xml.appendChild(element);
      }
      
      private static function encodeArrayItem(xml:XML, name:String, value:*, context:AMFXContext) : void
      {
         var item:XML = <item/>;
         item["name"] = name;
         encodeValue(item,value,context);
         xml.appendChild(item);
      }
      
      private static function encodeXML(xml:XML, xmlObject:Object) : void
      {
         var str:String = null;
         var x:XML = null;
         var element:XML = <xml/>;
         if(xmlObject is XML)
         {
            str = XML(xmlObject).toXMLString();
         }
         else
         {
            str = xmlObject.toString();
         }
         if(str.length > 0)
         {
            str = escapeXMLString(str);
            x = new XML(str);
            element.appendChild(x);
         }
         xml.appendChild(element);
      }
      
      private static function encodeArray(xml:XML, array:Array, context:AMFXContext) : void
      {
         var element:XML = null;
         var named:Object = null;
         var ordinal:Array = null;
         var isECMAArray:Boolean = false;
         var member:String = null;
         var n:String = null;
         var ordinalLength:uint = 0;
         var dense:Boolean = false;
         var i:uint = 0;
         var num:int = 0;
         var o:* = undefined;
         var ref:int = context.findObject(array);
         if(ref >= 0)
         {
            element = <ref/>;
            element["id"] = String(ref);
         }
         else
         {
            context.addObject(array);
            element = <array/>;
            named = {};
            ordinal = [];
            isECMAArray = false;
            for(member in array)
            {
               if(isNaN(Number(member)))
               {
                  named[member] = array[member];
                  isECMAArray = true;
               }
               else
               {
                  num = parseInt(member);
                  ordinal[num] = array[num];
               }
            }
            for(n in named)
            {
               encodeArrayItem(element,n,named[n],context);
            }
            ordinalLength = 0;
            dense = true;
            for(i = 0; i < ordinal.length; i++)
            {
               o = ordinal[i];
               if(o !== undefined)
               {
                  if(dense)
                  {
                     encodeValue(element,o,context);
                     ordinalLength++;
                  }
                  else
                  {
                     isECMAArray = true;
                     encodeArrayItem(element,String(i),o,context);
                  }
               }
               else
               {
                  dense = false;
               }
            }
            element["length"] = String(ordinalLength);
            if(isECMAArray)
            {
               element["ecma"] = "true";
            }
         }
         xml.appendChild(element);
      }
      
      private static function encodeDate(xml:XML, date:Date, context:AMFXContext) : void
      {
         var element:XML = null;
         var ref:int = context.findObject(date);
         if(ref >= 0)
         {
            element = <ref/>;
            element["id"] = String(ref);
         }
         else
         {
            context.addObject(date);
            element = <date/>;
            element.appendChild(new XML(date.getTime().toString()));
         }
         xml.appendChild(element);
      }
      
      private static function encodeBoolean(xml:XML, bool:Boolean) : void
      {
         if(bool)
         {
            xml.appendChild(X_TRUE.copy());
         }
         else
         {
            xml.appendChild(X_FALSE.copy());
         }
      }
      
      private static function encodeObject(xml:XML, obj:*, context:AMFXContext) : void
      {
         var element:XML = null;
         var classInfo:Object = null;
         var className:String = null;
         var classAlias:String = null;
         var properties:Array = null;
         var count:uint = 0;
         var remoteClassName:String = null;
         var cinfo:XML = null;
         var ext:IExternalizable = null;
         var ba:ByteArray = null;
         var i:uint = 0;
         var prop:String = null;
         var ref:int = context.findObject(obj);
         if(ref >= 0)
         {
            element = <ref/>;
            element["id"] = String(ref);
         }
         else
         {
            context.addObject(obj);
            element = <object/>;
            classInfo = ObjectUtil.getClassInfo(obj,null,CLASS_INFO_OPTIONS);
            className = classInfo.name;
            classAlias = classInfo.alias;
            properties = classInfo.properties;
            count = properties.length;
            if(obj is ObjectProxy)
            {
               cinfo = describeType(obj);
               className = cinfo.@name.toString();
               classAlias = cinfo.@alias.toString();
            }
            remoteClassName = classAlias != null ? classAlias : className;
            if(Boolean(remoteClassName) && Boolean(remoteClassName != "Object") && remoteClassName != "Array")
            {
               element["type"] = remoteClassName.replace(REGEX_CLASSNAME,".");
            }
            if(obj is IExternalizable)
            {
               classInfo.externalizable = true;
               encodeTraits(element,classInfo,context);
               ext = IExternalizable(obj);
               ba = new ByteArray();
               ext.writeExternal(ba);
               encodeByteArray(element,ba);
            }
            else
            {
               classInfo.externalizable = false;
               encodeTraits(element,classInfo,context);
               for(i = 0; i < count; i++)
               {
                  prop = properties[i];
                  encodeValue(element,obj[prop],context);
               }
            }
         }
         xml.appendChild(element);
      }
      
      public static function encodeValue(xml:XML, obj:*, context:AMFXContext) : void
      {
         if(obj != null)
         {
            if(obj is String)
            {
               encodeString(xml,String(obj),context);
            }
            else if(obj is Number)
            {
               encodeNumber(xml,Number(obj));
            }
            else if(obj is Boolean)
            {
               encodeBoolean(xml,Boolean(obj));
            }
            else if(obj is ByteArray)
            {
               encodeByteArray(xml,ByteArray(obj));
            }
            else if(obj is Array)
            {
               encodeArray(xml,obj as Array,context);
            }
            else if(obj is XML || obj is XMLDocument)
            {
               encodeXML(xml,obj);
            }
            else if(obj is Date)
            {
               encodeDate(xml,obj as Date,context);
            }
            else if(obj is Class)
            {
               if(Boolean(context.log))
               {
                  context.log.warn("Cannot serialize type Class");
               }
            }
            else
            {
               encodeObject(xml,obj,context);
            }
         }
         else if(obj === undefined)
         {
            xml.appendChild(X_UNDEFINED.copy());
         }
         else
         {
            xml.appendChild(X_NULL.copy());
         }
      }
      
      private static function encodePacket(xml:XML, obj:Object, headers:Array = null, context:AMFXContext = null) : void
      {
         if(Boolean(headers))
         {
            encodeHeaders(xml,headers,context);
         }
         encodeBody(xml,obj,context);
      }
      
      private static function encodeNumber(xml:XML, num:Number) : void
      {
         var element:XML = null;
         if(num is int || num is uint)
         {
            element = <int/>;
         }
         else
         {
            element = <double/>;
         }
         element.appendChild(new XML(num.toString()));
         xml.appendChild(element);
      }
      
      public function encode(obj:Object, headers:Array = null) : XML
      {
         XML.setSettings(settings);
         var xml:XML = <amfx />;
         xml.setNamespace(NAMESPACE);
         xml["ver"] = CURRENT_VERSION;
         var context:AMFXContext = new AMFXContext();
         context.log = Log.getLogger("mx.messaging.channels.amfx.AMFXEncoder");
         encodePacket(xml,obj,headers,context);
         return xml;
      }
   }
}

