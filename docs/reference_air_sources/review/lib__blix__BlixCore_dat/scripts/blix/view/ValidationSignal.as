package blix.view
{
   import flash.utils.Dictionary;
   
   public final class ValidationSignal
   {
      
      private var targets:Vector.<IValidatable> = new Vector.<IValidatable>();
      
      private var targetDict:Dictionary = new Dictionary(true);
      
      private var iterator:int = -1;
      
      private var targetsL:int;
      
      public function ValidationSignal()
      {
         super();
      }
      
      public function add(param1:IValidatable) : Boolean
      {
         if(this.targetDict[param1] == true)
         {
            return false;
         }
         this.targetDict[param1] = true;
         var _loc2_:int = this.getTargetIndex(param1);
         this.targets.splice(_loc2_,0,param1);
         ++this.targetsL;
         return true;
      }
      
      private function getTargetIndex(param1:IValidatable) : int
      {
         var _loc5_:int = 0;
         var _loc2_:int = this.iterator + 1;
         var _loc3_:int = this.targetsL;
         if(_loc2_ >= _loc3_)
         {
            return _loc3_;
         }
         var _loc4_:Number = param1.getValidationWeight();
         if(_loc4_ >= this.targets[_loc3_ - 1].getValidationWeight())
         {
            return _loc3_;
         }
         while(_loc2_ != _loc3_)
         {
            _loc5_ = _loc2_ + _loc3_ >> 1;
            if(_loc4_ >= this.targets[_loc5_].getValidationWeight())
            {
               _loc2_ = _loc5_ + 1;
            }
            else
            {
               _loc3_ = _loc5_;
            }
         }
         return _loc2_;
      }
      
      public function remove(param1:IValidatable) : Boolean
      {
         if(this.targetDict[param1] != true)
         {
            return false;
         }
         var _loc2_:int = this.targets.indexOf(param1);
         if(_loc2_ <= this.iterator)
         {
            --this.iterator;
         }
         this.targets.splice(_loc2_,1);
         delete this.targetDict[param1];
         --this.targetsL;
         return true;
      }
      
      public function removeAll() : void
      {
         this.targetDict = new Dictionary(true);
         this.targets.length = 0;
         this.targetsL = 0;
         this.iterator = 0;
      }
      
      public function dispatch() : void
      {
         var caughtError:Error = null;
         var target:IValidatable = null;
         if(this.targetsL == 0)
         {
            return;
         }
         this.iterator = 0;
         while(this.iterator < this.targetsL)
         {
            target = this.targets[this.iterator];
            try
            {
               target.validate();
            }
            catch(error:Error)
            {
               caughtError = error;
            }
            ++this.iterator;
         }
         this.targetDict = new Dictionary(true);
         this.targets.length = 0;
         this.targetsL = 0;
         this.iterator = -1;
         if(Boolean(caughtError))
         {
            throw caughtError;
         }
      }
      
      public function getHasListeners() : Boolean
      {
         return this.targetsL > 0;
      }
   }
}

