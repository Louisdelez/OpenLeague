package mx.charts.chartClasses
{
   import flash.text.TextFormat;
   import mx.core.ClassFactory;
   import mx.core.ContextualClassFactory;
   import mx.core.IFactory;
   import mx.core.UITextField;
   
   public class InstanceCache
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var creationCallback:Function;
      
      private var _parent:Object;
      
      [Inspectable(environment="none")]
      public var hide:Boolean = true;
      
      private var _factory:IFactory;
      
      private var _format:TextFormat;
      
      [Inspectable(environment="none")]
      public var remove:Boolean = false;
      
      [Inspectable(environment="none")]
      public var discard:Boolean = false;
      
      private var _insertPosition:int;
      
      private var _props:Object = {};
      
      private var _class:Class = null;
      
      private var _instanceCount:int = 0;
      
      private var _instances:Array = [];
      
      public function InstanceCache(type:Object, parent:Object = null, insertPosition:int = -1)
      {
         super();
         _parent = parent;
         if(type is IFactory)
         {
            _factory = IFactory(type);
         }
         else if(type is Class)
         {
            _class = Class(type);
            _factory = new ContextualClassFactory(Class(type));
         }
         _insertPosition = insertPosition;
      }
      
      private function applyProperties(start:int, end:int) : void
      {
         var newInst:Object = null;
         var aProp:String = null;
         for(var i:int = start; i < end; i++)
         {
            newInst = _instances[i];
            for(aProp in _props)
            {
               newInst[aProp] = _props[aProp];
            }
         }
      }
      
      [Inspectable(environment="none")]
      public function get instances() : Array
      {
         return _instances;
      }
      
      [Inspectable(environment="none")]
      public function get factory() : IFactory
      {
         return _factory;
      }
      
      private function applyFormat(start:int, end:int) : void
      {
         var newField:UITextField = null;
         for(var i:int = start; i < end; i++)
         {
            newField = _instances[i];
            newField.setTextFormat(_format);
            newField.defaultTextFormat = _format;
         }
      }
      
      [Inspectable(environment="none")]
      public function get count() : int
      {
         return _instanceCount;
      }
      
      [Inspectable(environment="none")]
      public function set insertPosition(value:int) : void
      {
         var i:int = 0;
         if(value != _insertPosition)
         {
            _insertPosition = value;
            if(Boolean(_parent))
            {
               for(i = 0; i < _instances.length; i++)
               {
                  _parent.setChildIndex(_instances[i],i + _insertPosition);
               }
            }
         }
      }
      
      public function set factory(value:IFactory) : void
      {
         if(value == _factory || value is ClassFactory && _factory is ClassFactory && ClassFactory(_factory).generator == ClassFactory(value).generator && !(value is ContextualClassFactory))
         {
            return;
         }
         _factory = value;
         _class = null;
         var instanceCount:Number = _instanceCount;
         count = 0;
         count = instanceCount;
      }
      
      public function set count(value:int) : void
      {
         var insertBase:int = 0;
         var i:int = 0;
         var newInst:Object = null;
         if(value == _instanceCount)
         {
            return;
         }
         var newInstanceCount:int = value;
         var oldInstanceCount:int = _instanceCount;
         var availableInstanceCount:int = int(_instances.length);
         if(_parent != null)
         {
            insertBase = Math.min(_insertPosition,_parent.numChildren - availableInstanceCount);
         }
         if(newInstanceCount > oldInstanceCount)
         {
            if(!_factory)
            {
               value = 0;
            }
            else
            {
               i = oldInstanceCount;
               while(i < newInstanceCount && i < availableInstanceCount)
               {
                  if(hide)
                  {
                     _instances[i].visible = true;
                  }
                  if(Boolean(_parent) && remove)
                  {
                     if(insertBase >= 0)
                     {
                        _parent.addChildAt(_instances[i],insertBase + i);
                     }
                     else
                     {
                        _parent.addChild(_instances[i]);
                     }
                  }
                  i++;
               }
               while(i < newInstanceCount)
               {
                  newInst = _factory.newInstance();
                  if(Boolean(_parent))
                  {
                     if(insertBase > 0)
                     {
                        _parent.addChildAt(newInst,insertBase + i);
                     }
                     else
                     {
                        _parent.addChild(newInst);
                     }
                  }
                  if(creationCallback != null)
                  {
                     creationCallback(newInst,this);
                  }
                  _instances.push(newInst);
                  i++;
               }
               applyProperties(availableInstanceCount,newInstanceCount);
               if(Boolean(_format))
               {
                  applyFormat(availableInstanceCount,newInstanceCount);
               }
            }
         }
         else if(newInstanceCount < oldInstanceCount)
         {
            if(remove)
            {
               for(i = newInstanceCount; i < oldInstanceCount; i++)
               {
                  _parent.removeChild(_instances[i]);
               }
            }
            if(hide)
            {
               for(i = newInstanceCount; i < oldInstanceCount; i++)
               {
                  _instances[i].visible = false;
               }
            }
            if(discard)
            {
               _instances = _instances.slice(0,newInstanceCount);
            }
         }
         _instanceCount = value;
      }
      
      public function set properties(value:Object) : void
      {
         _props = value;
         applyProperties(0,_instances.length);
      }
      
      public function set format(value:TextFormat) : void
      {
         _format = value;
         if(Boolean(_format))
         {
            applyFormat(0,_instances.length);
         }
      }
      
      [Inspectable(environment="none")]
      public function get format() : TextFormat
      {
         return _format;
      }
      
      [Inspectable(environment="none")]
      public function get properties() : Object
      {
         return _props;
      }
   }
}

