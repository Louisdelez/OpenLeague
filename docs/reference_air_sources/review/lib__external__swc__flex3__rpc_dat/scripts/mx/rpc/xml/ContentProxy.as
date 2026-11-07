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
      
      private var _isSimple:Boolean = true;
      
      private var _content:*;
      
      private var _propertyList:Array;
      
      private var _makeObjectsBindable:Boolean;
      
      public function ContentProxy(content:* = undefined, makeObjectsBindable:Boolean = false, isSimple:Boolean = true)
      {
         super();
      }
      
      override flash_proxy function deleteProperty(name:*) : Boolean
      {
         var deleted:Boolean = false;
         var oldVal:Object = null;
         if(!_isSimple && _content != null)
         {
            oldVal = _content[name];
            deleted = delete _content[name];
         }
         return deleted;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function set makeObjectsBindable(value:Boolean) : void
      {
         _makeObjectsBindable = value;
         if(value && !_isSimple && !(_content is ObjectProxy))
         {
            _content = new ObjectProxy(_content);
         }
      }
      
      override flash_proxy function nextValue(index:int) : *
      {
         if(!_isSimple && _content != null)
         {
            return _content[_propertyList[index - 1]];
         }
         return undefined;
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         if(_content != null)
         {
            return _content[name];
         }
         return undefined;
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         var hasProperty:Boolean = false;
         if(_content != null)
         {
            hasProperty = name in _content;
         }
         return hasProperty;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function setupPropertyList() : void
      {
         var prop:String = null;
         if(getQualifiedClassName(_content) == "Object")
         {
            _propertyList = [];
            for(prop in _content)
            {
               _propertyList.push(prop);
            }
         }
         else
         {
            _propertyList = ObjectUtil.getClassInfo(_content,null,{
               "includeReadOnly":false,
               "uris":["*"]
            }).properties;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function set content(value:*) : void
      {
         if(value is ContentProxy)
         {
            value = ContentProxy(value).object_proxy::content;
         }
         _content = value;
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         if(index == 0)
         {
            object_proxy::setupPropertyList();
         }
         if(index < _propertyList.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var oldContent:* = undefined;
         if(_isSimple)
         {
            oldContent = _content;
            if(oldContent !== value)
            {
               _content = value;
            }
         }
         else
         {
            if(_content == null)
            {
               _content = object_proxy::createObject();
            }
            oldContent = _content[name];
            if(oldContent !== value)
            {
               _content[name] = value;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function set isSimple(value:Boolean) : void
      {
         _isSimple = value;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function get content() : *
      {
         return _content;
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         if(_content != null)
         {
            return _content[name].apply(_content,rest);
         }
         return undefined;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function createObject() : *
      {
         if(object_proxy::makeObjectsBindable)
         {
            return new ObjectProxy();
         }
         return {};
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function get isSimple() : Boolean
      {
         return _isSimple;
      }
      
      §§namespace("http://www.adobe.com/2006/actionscript/flash/objectproxy") function get makeObjectsBindable() : Boolean
      {
         return _makeObjectsBindable;
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return _propertyList[index - 1];
      }
   }
}

