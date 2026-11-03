package blix.decorator
{
   import flash.utils.Dictionary;
   
   public class DecoratorManager implements IDecoratorManager
   {
      
      private var targetDecoratorsDict:Dictionary = new Dictionary(true);
      
      private var decorators:Vector.<IDecorator> = new Vector.<IDecorator>();
      
      public function DecoratorManager()
      {
         super();
      }
      
      public function addDecorator(param1:IDecorator) : void
      {
         var _loc2_:IDecoratable = null;
         if(param1 == null)
         {
            throw new Error("decorator cannot be null.");
         }
         for each(_loc2_ in this.getTargetsForDecorator(param1))
         {
            param1.apply(_loc2_);
            (this.targetDecoratorsDict[_loc2_] as Vector.<IDecorator>).push(param1);
         }
         this.decorators[this.decorators.length] = param1;
      }
      
      public function removeDecorator(param1:IDecorator) : void
      {
         var _loc3_:IDecoratable = null;
         var _loc2_:int = this.decorators.indexOf(param1);
         if(_loc2_ != -1)
         {
            for each(_loc3_ in this.getTargetsForDecorator(param1))
            {
               param1.unapply(_loc3_);
            }
            this.decorators.splice(_loc2_,1);
         }
      }
      
      public function addTarget(param1:IDecoratable) : void
      {
         var _loc3_:IDecorator = null;
         if(param1 == null)
         {
            throw new Error("target cannot be null.");
         }
         if(param1 in this.targetDecoratorsDict)
         {
            throw new Error("target already added.");
         }
         var _loc2_:Vector.<IDecorator> = this.getDecoratorsForTarget(param1);
         this.targetDecoratorsDict[param1] = _loc2_;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.apply(param1);
         }
      }
      
      public function removeTarget(param1:IDecoratable) : void
      {
         var _loc2_:IDecorator = null;
         for each(_loc2_ in this.targetDecoratorsDict[param1])
         {
            _loc2_.unapply(param1);
         }
         delete this.targetDecoratorsDict[param1];
      }
      
      private function getTargetsForDecorator(param1:IDecorator) : Vector.<IDecoratable>
      {
         var _loc4_:Object = null;
         var _loc5_:IDecoratable = null;
         var _loc6_:Class = null;
         var _loc2_:Vector.<IDecoratable> = new Vector.<IDecoratable>();
         var _loc3_:Boolean = param1.getIsInheritable();
         for(_loc4_ in this.targetDecoratorsDict)
         {
            _loc5_ = _loc4_ as IDecoratable;
            _loc6_ = param1.getDecoratedClass();
            if(_loc3_)
            {
               if(_loc5_ is _loc6_)
               {
                  _loc2_[_loc2_.length] = _loc5_;
               }
            }
            else if((_loc5_ as Object).constructor == _loc6_)
            {
               _loc2_[_loc2_.length] = _loc5_;
            }
         }
         return _loc2_;
      }
      
      private function getDecoratorsForTarget(param1:IDecoratable) : Vector.<IDecorator>
      {
         var _loc3_:IDecorator = null;
         var _loc4_:Class = null;
         var _loc2_:Vector.<IDecorator> = new Vector.<IDecorator>();
         for each(_loc3_ in this.decorators)
         {
            _loc4_ = _loc3_.getDecoratedClass();
            if(_loc3_.getIsInheritable())
            {
               if(param1 is _loc4_)
               {
                  _loc2_[_loc2_.length] = _loc3_;
               }
            }
            else if((param1 as Object).constructor == _loc4_)
            {
               _loc2_[_loc2_.length] = _loc3_;
            }
         }
         return _loc2_;
      }
   }
}

