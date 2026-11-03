package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.account.AccountForPublicView")]
   public class PartialAccount implements IEventDispatcher
   {
      
      public static const VERIFICATION_EXCEPTION:String = "com.riotgames.platform.ValidationException";
      
      private var _1422950650active:Boolean;
      
      private var _1218714947address1:String;
      
      private var _96619420email:String;
      
      private var _1218714946address2:String;
      
      private var _386871910dateOfBirth:Date;
      
      private var _132835675firstName:String;
      
      private var _1459599807lastName:String;
      
      private var _631494470securityQuestion:String;
      
      private var _3355id:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _109757585state:String;
      
      private var _957831062country:String;
      
      private var _266666762userName:String;
      
      private var _3053931city:String;
      
      private var _120609zip:String;
      
      public function PartialAccount()
      {
         super();
      }
      
      public function set lastName(param1:String) : void
      {
         var _loc2_:Object = this._1459599807lastName;
         if(_loc2_ !== param1)
         {
            this._1459599807lastName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get state() : String
      {
         return this._109757585state;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Object = this._1422950650active;
         if(_loc2_ !== param1)
         {
            this._1422950650active = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get active() : Boolean
      {
         return this._1422950650active;
      }
      
      [Bindable(event="propertyChange")]
      public function get country() : String
      {
         return this._957831062country;
      }
      
      [Bindable(event="propertyChange")]
      public function get dateOfBirth() : Date
      {
         return this._386871910dateOfBirth;
      }
      
      [Bindable(event="propertyChange")]
      public function get email() : String
      {
         return this._96619420email;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get zip() : String
      {
         return this._120609zip;
      }
      
      public function set state(param1:String) : void
      {
         var _loc2_:Object = this._109757585state;
         if(_loc2_ !== param1)
         {
            this._109757585state = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"state",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
      }
      
      public function set country(param1:String) : void
      {
         var _loc2_:Object = this._957831062country;
         if(_loc2_ !== param1)
         {
            this._957831062country = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"country",_loc2_,param1));
         }
      }
      
      public function set securityQuestion(param1:String) : void
      {
         var _loc2_:Object = this._631494470securityQuestion;
         if(_loc2_ !== param1)
         {
            this._631494470securityQuestion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"securityQuestion",_loc2_,param1));
         }
      }
      
      public function set dateOfBirth(param1:Date) : void
      {
         var _loc2_:Object = this._386871910dateOfBirth;
         if(_loc2_ !== param1)
         {
            this._386871910dateOfBirth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dateOfBirth",_loc2_,param1));
         }
      }
      
      public function set firstName(param1:String) : void
      {
         var _loc2_:Object = this._132835675firstName;
         if(_loc2_ !== param1)
         {
            this._132835675firstName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstName",_loc2_,param1));
         }
      }
      
      public function set email(param1:String) : void
      {
         var _loc2_:Object = this._96619420email;
         if(_loc2_ !== param1)
         {
            this._96619420email = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"email",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get address1() : String
      {
         return this._1218714947address1;
      }
      
      [Bindable(event="propertyChange")]
      public function get address2() : String
      {
         return this._1218714946address2;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get lastName() : String
      {
         return this._1459599807lastName;
      }
      
      public function set zip(param1:String) : void
      {
         var _loc2_:Object = this._120609zip;
         if(_loc2_ !== param1)
         {
            this._120609zip = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"zip",_loc2_,param1));
         }
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get securityQuestion() : String
      {
         return this._631494470securityQuestion;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set city(param1:String) : void
      {
         var _loc2_:Object = this._3053931city;
         if(_loc2_ !== param1)
         {
            this._3053931city = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"city",_loc2_,param1));
         }
      }
      
      public function get readOnlyEmail() : String
      {
         var _loc1_:Number = NaN;
         if(this.email != null)
         {
            _loc1_ = this.email.indexOf("@");
            if(_loc1_ == -1)
            {
               return "";
            }
            return this.email.charAt(0) + "..." + this.email.substr(_loc1_,this.email.length);
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get firstName() : String
      {
         return this._132835675firstName;
      }
      
      [Bindable(event="propertyChange")]
      public function get city() : String
      {
         return this._3053931city;
      }
      
      public function set userName(param1:String) : void
      {
         var _loc2_:Object = this._266666762userName;
         if(_loc2_ !== param1)
         {
            this._266666762userName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userName() : String
      {
         return this._266666762userName;
      }
      
      public function set address1(param1:String) : void
      {
         var _loc2_:Object = this._1218714947address1;
         if(_loc2_ !== param1)
         {
            this._1218714947address1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"address1",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set address2(param1:String) : void
      {
         var _loc2_:Object = this._1218714946address2;
         if(_loc2_ !== param1)
         {
            this._1218714946address2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"address2",_loc2_,param1));
         }
      }
   }
}

