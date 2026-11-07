package mx.effects
{
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   import mx.core.mx_internal;
   import mx.effects.effectClasses.SoundEffectInstance;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("effects")]
   [Event(name="progress",type="flash.events.ProgressEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="id3",type="flash.events.Event")]
   [Event(name="complete",type="flash.events.Event")]
   public class SoundEffect extends Effect
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var needsLoading:Boolean = false;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _autoLoad:Boolean = true;
      
      [Inspectable(category="General",defaultValue="1000")]
      public var bufferTime:Number = 1000;
      
      [Inspectable(category="General",defaultValue="0")]
      public var loops:int = 0;
      
      public var panEasingFunction:Function;
      
      [Inspectable(category="General",defaultValue="0.0")]
      public var panFrom:Number;
      
      [Inspectable(category="General",defaultValue="0.0")]
      public var panTo:Number;
      
      private var _sound:Sound;
      
      private var _source:Object;
      
      [Inspectable(category="General",defaultValue="0")]
      public var startTime:Number = 0;
      
      [Inspectable(category="General",defaultValue="true")]
      public var useDuration:Boolean = true;
      
      public var volumeEasingFunction:Function;
      
      [Inspectable(category="General",defaultValue="1.0")]
      public var volumeFrom:Number;
      
      [Inspectable(category="General",defaultValue="1.0")]
      public var volumeTo:Number;
      
      public function SoundEffect(target:Object = null)
      {
         super(target);
         instanceClass = SoundEffectInstance;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoLoad() : Boolean
      {
         return this._autoLoad;
      }
      
      public function set autoLoad(value:Boolean) : void
      {
         this._autoLoad = value;
      }
      
      public function get isLoading() : Boolean
      {
         if(Boolean(this._sound))
         {
            return this._sound.bytesTotal > 0;
         }
         return false;
      }
      
      public function get sound() : Sound
      {
         return this._sound;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get source() : Object
      {
         return this._source;
      }
      
      public function set source(value:Object) : void
      {
         var cls:Class = null;
         var message:String = null;
         if(Boolean(this._sound))
         {
            try
            {
               this._sound.close();
            }
            catch(e:IOError)
            {
            }
            this.removeSoundListeners();
         }
         this._source = value;
         if(this._source is Class)
         {
            cls = Class(this._source);
            this._sound = new cls();
            this.attachSoundListeners();
         }
         else
         {
            if(!(this._source is String))
            {
               message = this.resourceManager.getString("effects","incorrectSource");
               throw new Error(message);
            }
            this.needsLoading = true;
            this._sound = new Sound();
            this.attachSoundListeners();
         }
         if(this.autoLoad)
         {
            this.load();
         }
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var soundEffectInstance:SoundEffectInstance = null;
         super.initInstance(instance);
         soundEffectInstance = SoundEffectInstance(instance);
         soundEffectInstance.source = this.source;
         soundEffectInstance.sound = this.sound;
         soundEffectInstance.panFrom = this.panFrom;
         soundEffectInstance.panTo = this.panTo;
         soundEffectInstance.volumeFrom = this.volumeFrom;
         soundEffectInstance.volumeTo = this.volumeTo;
         soundEffectInstance.panEasingFunction = this.panEasingFunction;
         soundEffectInstance.volumeEasingFunction = this.volumeEasingFunction;
         soundEffectInstance.loops = this.loops;
         soundEffectInstance.startTime = this.startTime;
         soundEffectInstance.useDuration = this.useDuration;
      }
      
      public function load() : void
      {
         if(Boolean(this._sound && this._source) && Boolean(this._source is String) && this.needsLoading)
         {
            this._sound.load(new URLRequest(String(this._source)),new SoundLoaderContext(this.bufferTime));
         }
      }
      
      private function attachSoundListeners() : void
      {
         if(Boolean(this._sound))
         {
            this._sound.addEventListener(Event.COMPLETE,this.soundEventHandler);
            this._sound.addEventListener(ProgressEvent.PROGRESS,this.soundEventHandler);
            this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.soundEventHandler);
            this._sound.addEventListener(Event.ID3,this.soundEventHandler);
         }
      }
      
      private function removeSoundListeners() : void
      {
         if(Boolean(this._sound))
         {
            this._sound.removeEventListener(Event.COMPLETE,this.soundEventHandler);
            this._sound.removeEventListener(ProgressEvent.PROGRESS,this.soundEventHandler);
            this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.soundEventHandler);
            this._sound.removeEventListener(Event.ID3,this.soundEventHandler);
         }
      }
      
      private function soundEventHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

