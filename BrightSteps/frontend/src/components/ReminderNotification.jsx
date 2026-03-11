import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Bell } from 'lucide-react';
import axios from '../api/axiosInstance';
import { playCelebrationSound, speak } from '../utils/soundUtils';

const ReminderNotification = ({ childId }) => {
  const [activeReminder, setActiveReminder] = useState(null);
  const [dismissed, setDismissed] = useState(false);
  const [debugInfo, setDebugInfo] = useState({ currentTime: '', lastCheck: '', reminderCount: 0 });
  
  useEffect(() => {
    if (!childId) {
      console.log('❌ No childId for reminder check');
      return;
    }
    
    console.log('🔔 Starting reminder check for child:', childId);
    
    // Check for active reminders
    const checkReminders = async () => {
      const now = new Date();
      const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
      const currentDay = now.getDay();
      const fullTime = now.toLocaleTimeString('en-US', { hour12: false });
      
      console.log(`⏰ [${fullTime}] Checking reminders at ${currentTime}, Day: ${currentDay}...`);
      
      try {
        const response = await axios.get(`/reminders/active/${childId}`);
        const reminders = response.data.data;
        
        setDebugInfo({
          currentTime: fullTime,
          lastCheck: currentTime,
          reminderCount: reminders?.length || 0,
        });
        
        console.log(`📋 Active reminders found: ${reminders?.length || 0}`, reminders);
        
        if (reminders && reminders.length > 0 && !dismissed) {
          const reminder = reminders[0]; // Show first active reminder
          console.log('🎯 SHOWING REMINDER NOW:', reminder);
          setActiveReminder(reminder);
          
          // Play sound and speak
          try {
            await playCelebrationSound();
            speak(reminder.title);
            
            if (reminder.message) {
              setTimeout(() => {
                speak(reminder.message);
              }, 2000);
            }
          } catch (soundError) {
            console.error('Sound/speech error:', soundError);
          }
        } else {
          if (dismissed) {
            console.log('⏭️ Reminder dismissed by user');
          } else {
            console.log('⬜ No active reminders for current time');
          }
        }
      } catch (error) {
        console.error('❌ Error checking reminders:', error);
        console.error('Error details:', error.response?.data);
      }
    };
    
    // Check immediately
    checkReminders();
    
    // Then check every 10 seconds (for testing - change to 60000 for production)
    const interval = setInterval(checkReminders, 10000);
    
    return () => {
      console.log('🔕 Stopping reminder checks');
      clearInterval(interval);
    };
  }, [childId, dismissed]);
  
  const handleDismiss = () => {
    setDismissed(true);
    setActiveReminder(null);
    
    // Reset dismissed after 5 minutes
    setTimeout(() => {
      setDismissed(false);
    }, 300000);
  };
  
  return (
    <>
      {/* Debug Panel - Remove in production */}
      <div className="fixed top-4 right-4 bg-black bg-opacity-80 text-white p-4 rounded-lg text-xs z-40 max-w-xs">
        <div className="font-bold mb-2">🔔 Reminder Debug</div>
        <div className="space-y-1">
          <div>Time Now: <strong className="text-green-400">{debugInfo.currentTime}</strong></div>
          <div>Last Check: {debugInfo.lastCheck}</div>
          <div>Active Reminders: <strong className="text-yellow-400">{debugInfo.reminderCount}</strong></div>
          <div className="text-gray-400 text-xs mt-2">Updates every 10 seconds</div>
        </div>
      </div>
      
      <AnimatePresence>
        {activeReminder && !dismissed && (
        <motion.div
          initial={{ opacity: 0, scale: 0.8, y: 50 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.8, y: 50 }}
          className="fixed bottom-6 right-6 z-50 max-w-md"
        >
          <div className="bg-gradient-to-br from-yellow-400 via-orange-400 to-pink-400 rounded-2xl shadow-2xl p-6 border-4 border-white">
            <button
              onClick={handleDismiss}
              className="absolute top-2 right-2 w-8 h-8 bg-white rounded-full flex items-center justify-center hover:bg-gray-100 transition"
            >
              <X className="w-5 h-5 text-gray-700" />
            </button>
            
            <div className="text-center">
              <div className="text-6xl mb-4 animate-bounce">
                {activeReminder.type === 'breakfast' && '🥞'}
                {activeReminder.type === 'lunch' && '🍱'}
                {activeReminder.type === 'dinner' && '🍽️'}
                {activeReminder.type === 'snack' && '🍪'}
                {activeReminder.type === 'custom' && '🔔'}
              </div>
              
              <h3 className="text-3xl font-bold text-white mb-3 drop-shadow-lg">
                {activeReminder.title}
              </h3>
              
              {activeReminder.message && (
                <p className="text-xl text-white mb-4 drop-shadow">
                  {activeReminder.message}
                </p>
              )}
              
              <div className="bg-white bg-opacity-90 rounded-xl p-4 mb-4">
                <p className="text-2xl font-bold text-gray-800">
                  ⏰ {activeReminder.time}
                </p>
              </div>
              
              {activeReminder.songLyrics && (
                <div className="bg-white bg-opacity-80 rounded-lg p-3 mb-4">
                  <p className="text-sm text-gray-700 italic">
                    🎵 {activeReminder.songLyrics}
                  </p>
                </div>
              )}
              
              <button
                onClick={handleDismiss}
                className="w-full px-6 py-3 bg-white text-orange-600 rounded-xl font-bold text-lg hover:bg-gray-100 transition shadow-lg"
              >
                Got It! ✅
              </button>
            </div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
    </>
  );
};

export default ReminderNotification;

