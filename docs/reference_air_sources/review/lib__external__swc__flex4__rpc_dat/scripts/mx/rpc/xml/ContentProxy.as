package mx.rpc.xml
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   import mx.utils.ObjectProxy;
   import mx.utils.ObjectUtil;
   import mx.utils.object_proxy;
   
   use namespace flash_proxy;
   
   [ExcludeClass]
   public dynamic class ContentProxy extends Proxy
   {
      
      private var _content:*;
      
      private var _isSimple:Boolean = true;
      
      private var _makeObjectsBindable:Boolean;
      
      private var _propertyList:Array;
      
      public function ContentProxy(content:* = undefined, makeObjectsBindable:Boolean = false, isSimple:Boolean = true)
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function get makeObjectsBindable() : Boolean
      {
         return this._makeObjectsBindable;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function set makeObjectsBindable(value:Boolean) : void
      {
         this._makeObjectsBindable = value;
         if(value && !this._isSimple && !(this._content is ObjectProxy))
         {
            this._content = new ObjectProxy(this._content);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function get isSimple() : Boolean
      {
         return this._isSimple;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function set isSimple(value:Boolean) : void
      {
         this._isSimple = value;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function get content() : *
      {
         return this._content;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function set content(value:*) : void
      {
         if(value is ContentProxy)
         {
            value = ContentProxy(value).object_proxy::content;
         }
         this._content = value;
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         if(this._content != null)
         {
            return this._content[name];
         }
         return undefined;
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         if(this._content != null)
         {
            return this._content[name].apply(this._content,rest);
         }
         return undefined;
      }
      
      override flash_proxy function deleteProperty(name:*) : Boolean
      {
         var deleted:Boolean = false;
         var oldVal:Object = null;
         if(!this._isSimple && this._content != null)
         {
            oldVal = this._content[name];
            deleted = delete this._content[name];
         }
         return deleted;
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         var hasProperty:Boolean = false;
         if(this._content != null)
         {
            hasProperty = name in this._content;
         }
         return hasProperty;
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var oldContent:* = undefined;
         if(this._isSimple)
         {
            oldContent = this._content;
            if(oldContent !== value)
            {
               this._content = value;
            }
         }
         else
         {
            if(this._content == null)
            {
               this._content = object_proxy::createObject();
            }
            oldContent = this._content[name];
            if(oldContent !== value)
            {
               this._content[name] = value;
            }
         }
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return this._propertyList[index - 1];
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         if(index == 0)
         {
            object_proxy::setupPropertyList();
         }
         if(index < this._propertyList.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextValue(index:int) : *
      {
         if(!this._isSimple && this._content != null)
         {
            return this._content[this._propertyList[index - 1]];
         }
         return undefined;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function setupPropertyList() : void
      {
         var prop:String = null;
         if(getQualifiedClassName(this._content) == "Object")
         {
            this._propertyList = [];
            for(prop in this._content)
            {
               this._propertyList.push(prop);
            }
         }
         else
         {
            this._propertyList = ObjectUtil.getClassInfo(this._content,null,{
               "includeReadOnly":false,
               "uris":["*"]
            }).properties;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function createObject() : *
      {
         if(object_proxy::makeObjectsBindable)
         {
            return new ObjectProxy();
         }
         return {};
      }
   }
}

