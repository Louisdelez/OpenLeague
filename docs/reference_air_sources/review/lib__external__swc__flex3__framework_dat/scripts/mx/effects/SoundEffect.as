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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      [Inspectable(category="General",defaultValue="0")]
      public var loops:int = 0;
      
      private var _sound:Sound;
      
      private var _autoLoad:Boolean = true;
      
      public var volumeEasingFunction:Function;
      
      private var needsLoading:Boolean = false;
      
      public var panEasingFunction:Function;
      
      [Inspectable(category="General",defaultValue="1.0")]
      public var volumeFrom:Number;
      
      [Inspectable(category="General",defaultValue="1000")]
      public var bufferTime:Number = 1000;
      
      [Inspectable(category="General",defaultValue="0.0")]
      public var panFrom:Number;
      
      [Inspectable(category="General",defaultValue="0")]
      public var startTime:Number = 0;
      
      [Inspectable(category="General",defaultValue="0.0")]
      public var panTo:Number;
      
      private var _source:Object;
      
      [Inspectable(category="General",defaultValue="true")]
      public var useDuration:Boolean = true;
      
      [Inspectable(category="General",defaultValue="1.0")]
      public var volumeTo:Number;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function SoundEffect(target:Object = null)
      {
         super(target);
         instanceClass = SoundEffectInstance;
      }
      
      private function soundEventHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var soundEffectInstance:SoundEffectInstance = null;
         super.initInstance(instance);
         soundEffectInstance = SoundEffectInstance(instance);
         soundEffectInstance.source = source;
         soundEffectInstance.sound = sound;
         soundEffectInstance.panFrom = panFrom;
         soundEffectInstance.panTo = panTo;
         soundEffectInstance.volumeFrom = volumeFrom;
         soundEffectInstance.volumeTo = volumeTo;
         soundEffectInstance.panEasingFunction = panEasingFunction;
         soundEffectInstance.volumeEasingFunction = volumeEasingFunction;
         soundEffectInstance.loops = loops;
         soundEffectInstance.startTime = startTime;
         soundEffectInstance.useDuration = useDuration;
      }
      
      private function attachSoundListeners() : void
      {
         if(Boolean(_sound))
         {
            _sound.addEventListener(Event.COMPLETE,soundEventHandler);
            _sound.addEventListener(ProgressEvent.PROGRESS,soundEventHandler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR,soundEventHandler);
            _sound.addEventListener(Event.ID3,soundEventHandler);
         }
      }
      
      public function get sound() : Sound
      {
         return _sound;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get source() : Object
      {
         return _source;
      }
      
      private function removeSoundListeners() : void
      {
         if(Boolean(_sound))
         {
            _sound.removeEventListener(Event.COMPLETE,soundEventHandler);
            _sound.removeEventListener(ProgressEvent.PROGRESS,soundEventHandler);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR,soundEventHandler);
            _sound.removeEventListener(Event.ID3,soundEventHandler);
         }
      }
      
      public function load() : void
      {
         if(Boolean(_sound && _source) && Boolean(_source is String) && needsLoading)
         {
            _sound.load(new URLRequest(String(_source)),new SoundLoaderContext(bufferTime));
         }
      }
      
      public function set autoLoad(value:Boolean) : void
      {
         _autoLoad = value;
      }
      
      public function get isLoading() : Boolean
      {
         if(Boolean(_sound))
         {
            return _sound.bytesTotal > 0;
         }
         return false;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoLoad() : Boolean
      {
         return _autoLoad;
      }
      
      public function set source(value:Object) : void
      {
         var cls:Class = null;
         var message:String = null;
         if(Boolean(_sound))
         {
            try
            {
               _sound.close();
            }
            catch(e:IOError)
            {
            }
            removeSoundListeners();
         }
         _source = value;
         if(_source is Class)
         {
            cls = Class(_source);
            _sound = new cls();
            attachSoundListeners();
         }
         else
         {
            if(!(_source is String))
            {
               message = resourceManager.getString("effects","incorrectSource");
               throw new Error(message);
            }
            needsLoading = true;
            _sound = new Sound();
            attachSoundListeners();
         }
         if(autoLoad)
         {
            load();
         }
      }
   }
}

