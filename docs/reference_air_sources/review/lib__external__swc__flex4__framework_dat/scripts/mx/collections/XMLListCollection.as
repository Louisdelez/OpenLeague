package mx.collections
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [DefaultProperty("source")]
   public class XMLListCollection extends ListCollectionView
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function XMLListCollection(source:XMLList = null)
      {
         super();
         this.source = source;
      }
      
      [Bindable("listChanged")]
      [Inspectable(category="General")]
      public function get source() : XMLList
      {
         return Boolean(list) ? XMLListAdapter(list).source : null;
      }
      
      public function set source(s:XMLList) : void
      {
         if(Boolean(list))
         {
            XMLListAdapter(list).source = null;
         }
         list = new XMLListAdapter(s);
      }
      
      public function attribute(attributeName:Object) : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.attribute(attributeName);
         });
      }
      
      public function attributes() : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.attributes();
         });
      }
      
      public function child(propertyName:Object) : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.child(propertyName);
         });
      }
      
      public function children() : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.children();
         });
      }
      
      public function copy() : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return XMLList(obj.copy());
         });
      }
      
      public function descendants(name:Object = "*") : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.descendants(name);
         });
      }
      
      public function elements(name:String = "*") : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.elements(name);
         });
      }
      
      public function text() : XMLList
      {
         return this.execXMLListFunction(function(obj:Object):XMLList
         {
            return obj.text();
         });
      }
      
      override public function toString() : String
      {
         var str:String = null;
         var i:int = 0;
         if(!localIndex)
         {
            return this.source.toString();
         }
         str = "";
         for(i = 0; i < localIndex.length; i++)
         {
            if(i > 0)
            {
               str += "\n";
            }
            str += localIndex[i].toString();
         }
         return str;
      }
      
      public function toXMLString() : String
      {
         var str:String = null;
         var i:int = 0;
         if(!localIndex)
         {
            return this.source.toXMLString();
         }
         str = "";
         for(i = 0; i < localIndex.length; i++)
         {
            if(i > 0)
            {
               str += "\n";
            }
            str += localIndex[i].toXMLString();
         }
         return str;
      }
      
      private function execXMLListFunction(func:Function) : XMLList
      {
         var length:int = 0;
         var ret:XMLList = null;
         var i:int = 0;
         var xml:Object = null;
         if(!localIndex)
         {
            return func(this.source);
         }
         length = int(localIndex.length);
         ret = new XMLList("");
         for(i = 0; i < length; i++)
         {
            xml = localIndex[i];
            ret += func(xml);
         }
         return ret;
      }
   }
}

