package spark.filters
{
   import flash.display.Shader;
   import flash.display.ShaderInput;
   import flash.display.ShaderParameter;
   import flash.display.ShaderParameterType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filters.BitmapFilter;
   import flash.filters.ShaderFilter;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import mx.filters.BaseFilter;
   import mx.filters.IBitmapFilter;
   
   use namespace flash_proxy;
   
   public dynamic class ShaderFilter extends Proxy implements IBitmapFilter, IEventDispatcher
   {
      
      private var propertyQueue:Object;
      
      private var _shader:Shader;
      
      private var _shaderClass:Class;
      
      private var _bottomExtension:int = 0;
      
      private var _topExtension:int = 0;
      
      private var _leftExtension:int = 0;
      
      private var _rightExtension:int = 0;
      
      private var _precisionHint:String = "full";
      
      private var eventDispatcher:EventDispatcher;
      
      public function ShaderFilter(shader:Object = null)
      {
         super();
         this.eventDispatcher = new EventDispatcher();
         this.shader = shader;
      }
      
      public function set shader(value:*) : void
      {
         var obj:Object = null;
         if(value is Shader && value != this._shader)
         {
            this._shader = value;
         }
         else if(value is Class && value != this._shaderClass)
         {
            obj = new value();
            this._shader = obj as Shader;
            this._shaderClass = value;
         }
         this.applyQueuedProperties();
         this.notifyFilterChanged();
      }
      
      public function get shader() : Shader
      {
         return this._shader;
      }
      
      public function get bottomExtension() : int
      {
         return this._bottomExtension;
      }
      
      public function set bottomExtension(value:int) : void
      {
         if(value == this._bottomExtension)
         {
            return;
         }
         this._bottomExtension = value;
         this.notifyFilterChanged();
      }
      
      public function get topExtension() : int
      {
         return this._topExtension;
      }
      
      public function set topExtension(value:int) : void
      {
         if(value == this._topExtension)
         {
            return;
         }
         this._topExtension = value;
         this.notifyFilterChanged();
      }
      
      public function get leftExtension() : int
      {
         return this._leftExtension;
      }
      
      public function set leftExtension(value:int) : void
      {
         if(value == this._leftExtension)
         {
            return;
         }
         this._leftExtension = value;
         this.notifyFilterChanged();
      }
      
      public function get rightExtension() : int
      {
         return this._rightExtension;
      }
      
      public function set rightExtension(value:int) : void
      {
         if(value == this._rightExtension)
         {
            return;
         }
         this._rightExtension = value;
         this.notifyFilterChanged();
      }
      
      public function get precisionHint() : String
      {
         return this._precisionHint;
      }
      
      public function set precisionHint(value:String) : void
      {
         if(value == this._precisionHint)
         {
            return;
         }
         this._precisionHint = value;
         this.notifyFilterChanged();
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         return Boolean(this._shader) ? this.retrieveShaderProperty(name) : this.propertyQueue[name];
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         if(Boolean(this._shader))
         {
            this.applyProperty(name.toString(),value);
            this.notifyFilterChanged();
         }
         else
         {
            this.propertyQueue = Boolean(this.propertyQueue) ? this.propertyQueue : new Object();
            this.propertyQueue[name] = value;
         }
      }
      
      override flash_proxy function callProperty(name:*, ... args) : *
      {
         if(Boolean(this._shader))
         {
            return this._shader[name].apply(this._shader,args);
         }
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         if(!this._shader || !name || name == "")
         {
            return false;
         }
         var index:int = int(name.indexOf("_"));
         var prefix:String = index > 0 ? name.substring(0,index) : name;
         return name in this._shader || name in this._shader.data || prefix in this._shader.data;
      }
      
      private function applyQueuedProperties() : void
      {
         var property:String = null;
         if(Boolean(this._shader))
         {
            for(property in this.propertyQueue)
            {
               this.applyProperty(property,this.propertyQueue[property]);
            }
            this.propertyQueue = null;
         }
      }
      
      private function applyProperty(property:String, value:*) : void
      {
         var suffix:String = null;
         var name:String = null;
         var dimension:String = null;
         var propertyInfo:ShaderParameter = null;
         var index:int = 0;
         var currentValue:Array = null;
         if(value == null)
         {
            return;
         }
         var suffixPattern:RegExp = /_.$/;
         var match:Array = property.match(suffixPattern);
         if(Boolean(match) && Boolean(match[0]) && !(value is Array))
         {
            suffix = match[0];
            name = property.substr(0,property.length - suffix.length);
            dimension = suffix.substr(suffix.length - 1,1);
            propertyInfo = this._shader.data[name];
            if(Boolean(propertyInfo))
            {
               index = this.indexForDimension(propertyInfo.type,dimension);
               if(index != -1)
               {
                  currentValue = Boolean(propertyInfo.value) ? propertyInfo.value : new Array();
                  currentValue[index] = value;
                  propertyInfo.value = currentValue;
                  return;
               }
            }
         }
         if(this._shader.data[property] is ShaderInput)
         {
            this._shader.data[property].input = value;
         }
         else
         {
            this._shader.data[property].value = value is Array ? value : [value];
         }
      }
      
      private function retrieveShaderProperty(name:*) : *
      {
         var suffix:String = null;
         var prop:String = null;
         var dimension:String = null;
         var propertyInfo:ShaderParameter = null;
         var index:int = 0;
         name = name is QName ? name.localName : name;
         var suffixPattern:RegExp = /_.$/;
         var match:Array = name.match(suffixPattern);
         if(Boolean(match) && Boolean(match[0]))
         {
            suffix = match[0];
            prop = name.substr(0,name.length - suffix.length);
            dimension = suffix.substr(suffix.length - 1,1);
            propertyInfo = this._shader.data[prop];
            if(Boolean(propertyInfo))
            {
               index = this.indexForDimension(propertyInfo.type,dimension);
               if(index != -1)
               {
                  return propertyInfo.value[index];
               }
            }
         }
         return this._shader.data[name] is ShaderInput ? this._shader.data[name].input : this._shader.data[name].value;
      }
      
      private function indexForDimension(type:String, dimension:String) : int
      {
         var index:int = 0;
         if(type == ShaderParameterType.MATRIX2X2 || type == ShaderParameterType.MATRIX3X3 || type == ShaderParameterType.MATRIX4X4)
         {
            index = dimension.charCodeAt(0) - 97;
         }
         else if(Number(type.charAt(type.length - 1)) > 0)
         {
            index = "rgba".indexOf(dimension);
            index = index == -1 ? "xyzw".indexOf(dimension) : index;
            index = index == -1 ? "stpq".indexOf(dimension) : index;
         }
         return index;
      }
      
      public function notifyFilterChanged() : void
      {
         this.dispatchEvent(new Event(BaseFilter.CHANGE));
      }
      
      public function clone() : BitmapFilter
      {
         var instance:flash.filters.ShaderFilter = null;
         if(Boolean(this._shader))
         {
            this._shader.precisionHint = Boolean(this._precisionHint) ? this._precisionHint : this._shader.precisionHint;
            instance = new flash.filters.ShaderFilter(this._shader);
            instance.bottomExtension = this._bottomExtension;
            instance.topExtension = this._topExtension;
            instance.leftExtension = this._leftExtension;
            instance.rightExtension = this._rightExtension;
         }
         return instance;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this.eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.eventDispatcher.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(type);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.eventDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.eventDispatcher.willTrigger(type);
      }
   }
}

