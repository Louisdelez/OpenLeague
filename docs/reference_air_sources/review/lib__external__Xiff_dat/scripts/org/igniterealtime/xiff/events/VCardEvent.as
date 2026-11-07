package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.vcard.VCard;
   
   public class VCardEvent extends Event
   {
      
      public static const LOADED:String = "vcardLoaded";
      
      public static const AVATAR_LOADED:String = "vcardAvatarLoaded";
      
      public static const ERROR:String = "vcardError";
      
      private var _vcard:VCard;
      
      public function VCardEvent(param1:String, param2:VCard, param3:Boolean, param4:Boolean)
      {
         super(param1,param3,param4);
         this._vcard = param2;
      }
      
      override public function clone() : Event
      {
         return new VCardEvent(type,this._vcard,bubbles,cancelable);
      }
      
      public function get vcard() : VCard
      {
         return this._vcard;
      }
   }
}

