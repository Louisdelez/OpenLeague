package blix.context
{
   import blix.util.UIDUtil;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class Context implements IContext
   {
      
      public const id:Number = UIDUtil.getNextId();
      
      private var _className:String;
      
      private var _superClassName:String;
      
      private var _ancestry:Vector.<IContext>;
      
      private var _dependencies:Dictionary;
      
      private var _ancestryLength:uint;
      
      public function Context(param1:IContext = null, param2:Dictionary = null)
      {
         var _loc3_:Vector.<IContext> = null;
         super();
         if(param1 != null)
         {
            _loc3_ = param1.getContextAncestry();
            this._ancestry = _loc3_.slice();
            this._ancestryLength = this._ancestry.length + 1;
         }
         else
         {
            this._ancestry = new Vector.<IContext>();
            this._ancestryLength = 1;
         }
         this._ancestry[this._ancestry.length] = this;
         this._dependencies = param2;
         this.initializeDependencies();
      }
      
      protected function initializeDependencies() : void
      {
      }
      
      protected function registerDependency(param1:Class, param2:Object, param3:Boolean = true) : Boolean
      {
         if(param1 == null)
         {
            throw new Error("The dependency contract may not be null.");
         }
         if(param3 == false && this.getDependency(param1) != null)
         {
            return false;
         }
         if(this._dependencies == null)
         {
            this._dependencies = new Dictionary(true);
         }
         this._dependencies[param1] = param2;
         return true;
      }
      
      protected function deleteDependency(param1:Class) : Boolean
      {
         if(param1 in this._dependencies)
         {
            delete this._dependencies[param1];
            return true;
         }
         return false;
      }
      
      public function getDependency(param1:Class, param2:Boolean = true) : *
      {
         var _loc4_:* = undefined;
         if(param2 == false)
         {
            if(this._dependencies == null)
            {
               return null;
            }
            return this._dependencies[param1];
         }
         var _loc3_:uint = this._ancestry.length;
         while(Boolean(_loc3_--))
         {
            _loc4_ = this._ancestry[_loc3_].getDependency(param1,false);
            if(_loc4_ != null)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getClassName() : String
      {
         if(!this._className)
         {
            this._className = getQualifiedClassName(this);
         }
         return this._className;
      }
      
      public function getSuperClassName() : String
      {
         if(!this._superClassName)
         {
            this._superClassName = getQualifiedSuperclassName(this);
         }
         return this._superClassName;
      }
      
      public function getContextAncestry() : Vector.<IContext>
      {
         return this._ancestry;
      }
      
      public function getAncestryLength() : uint
      {
         return this._ancestryLength;
      }
      
      public function getRootContext() : IContext
      {
         return this._ancestry[0];
      }
      
      public function getParentContext() : IContext
      {
         if(this._ancestry.length < 2)
         {
            return null;
         }
         return this._ancestry[this._ancestry.length - 2];
      }
      
      public function getFirstContext(param1:Class) : *
      {
         var _loc2_:uint = this._ancestry.length;
         while(Boolean(_loc2_--))
         {
            if(this._ancestry[_loc2_] is param1)
            {
               return this._ancestry[_loc2_];
            }
         }
         return null;
      }
      
      public function getLastContext(param1:Class) : *
      {
         var _loc2_:IContext = null;
         for each(_loc2_ in this._ancestry)
         {
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getChainToString() : String
      {
         var _loc1_:Array = this.getClassName().split("::");
         var _loc2_:String = _loc1_.pop() + this.id.toString();
         var _loc3_:IContext = this.getParentContext();
         if(_loc3_ == null)
         {
            return _loc2_;
         }
         return _loc3_.getChainToString() + "." + _loc2_;
      }
   }
}

