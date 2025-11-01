import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useAppStore } from '../store/useAppStore';
import axios from '../api/axiosInstance';
import Navbar from '../components/Navbar';
import { BarChart3, Users, Bell, Mail, Sparkles, Plus, User, Edit, Trash2, Send, Trophy, TrendingUp, Calendar } from 'lucide-react';
import StatsCard from '../components/StatsCard';
import ChartCard from '../components/ChartCard';
import { motion, AnimatePresence } from 'framer-motion';
import { formatDate } from '../utils/timeUtils';

const ParentDashboard = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const initialTab = searchParams.get('tab') || 'overview';
  
  const {
    isAuthenticated,
    children,
    currentChild,
    setCurrentChild,
    fetchChildren,
    createChild,
    progressData,
    fetchProgress,
    fetchDailyStats,
    dailyStats,
    reminders,
    fetchReminders,
    addReminder,
    updateReminder,
    deleteReminder,
    parent,
    updateParent,
    sendReport,
    fetchAIRecommendation,
    fetchParentTip,
    aiRecommendation,
    aiTips,
    loading,
    error,
    clearError,
  } = useAppStore();
  
  const [activeTab, setActiveTab] = useState(initialTab);
  const [selectedChild, setSelectedChild] = useState(null);
  const [showAddChildModal, setShowAddChildModal] = useState(false);
  const [showReminderModal, setShowReminderModal] = useState(false);
  const [period, setPeriod] = useState('week');
  
  useEffect(() => {
    if (!isAuthenticated) {
      navigate('/login');
      return;
    }
    
    loadData();
  }, [isAuthenticated]);
  
  const loadData = async () => {
    try {
      await fetchChildren();
    } catch (error) {
      console.error('Failed to load data:', error);
    }
  };
  
  useEffect(() => {
    if (children.length > 0 && !selectedChild) {
      handleSelectChild(children[0]);
    }
  }, [children]);
  
  const handleSelectChild = async (child) => {
    setSelectedChild(child);
    setCurrentChild(child);
    try {
      await Promise.all([
        fetchProgress(child._id, period),
        fetchDailyStats(child._id, period === 'day' ? 1 : period === 'week' ? 7 : 30),
        fetchReminders(child._id),
      ]);
    } catch (error) {
      console.error('Failed to load child data:', error);
    }
  };
  
  const tabs = [
    { id: 'overview', label: 'Progress Overview', icon: BarChart3 },
    { id: 'children', label: 'Children', icon: Users },
    { id: 'reminders', label: 'Reminders', icon: Bell },
    { id: 'email', label: 'Email Reports', icon: Mail },
    { id: 'ai', label: 'AI Insights', icon: Sparkles },
  ];
  
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      
      <div className="max-w-7xl mx-auto px-6 py-8">
        {/* Tabs */}
        <div className="flex gap-2 mb-8 overflow-x-auto">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 px-6 py-3 rounded-lg font-medium transition whitespace-nowrap ${
                  activeTab === tab.id
                    ? 'bg-purple-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-100'
                }`}
              >
                <Icon className="w-5 h-5" />
                {tab.label}
              </button>
            );
          })}
        </div>
        
        {/* Tab Content */}
        <AnimatePresence mode="wait">
          {activeTab === 'overview' && (
            <OverviewTab
              children={children}
              selectedChild={selectedChild}
              onSelectChild={handleSelectChild}
              progressData={progressData}
              dailyStats={dailyStats}
              period={period}
              setPeriod={setPeriod}
              fetchProgress={fetchProgress}
              fetchDailyStats={fetchDailyStats}
            />
          )}
          
          {activeTab === 'children' && (
            <ChildrenTab
              children={children}
              onAddChild={createChild}
              onSelectChild={setSelectedChild}
              showModal={showAddChildModal}
              setShowModal={setShowAddChildModal}
              loadData={loadData}
            />
          )}
          
          {activeTab === 'reminders' && (
            <RemindersTab
              children={children}
              selectedChild={selectedChild}
              onSelectChild={handleSelectChild}
              reminders={reminders}
              onAddReminder={addReminder}
              onUpdateReminder={updateReminder}
              onDeleteReminder={deleteReminder}
              showModal={showReminderModal}
              setShowModal={setShowReminderModal}
            />
          )}
          
          {activeTab === 'email' && (
            <EmailTab
              parent={parent}
              children={children}
              onUpdateParent={updateParent}
              onSendReport={sendReport}
            />
          )}
          
          {activeTab === 'ai' && (
            <AITab
              children={children}
              selectedChild={selectedChild}
              onSelectChild={handleSelectChild}
              aiRecommendation={aiRecommendation}
              aiTips={aiTips}
              onFetchRecommendation={fetchAIRecommendation}
              onFetchTip={fetchParentTip}
            />
          )}
        </AnimatePresence>
      </div>
    </div>
  );
};

// Overview Tab Component
const OverviewTab = ({ children, selectedChild, onSelectChild, progressData, dailyStats, period, setPeriod, fetchProgress, fetchDailyStats }) => {
  const handlePeriodChange = async (newPeriod) => {
    setPeriod(newPeriod);
    if (selectedChild) {
      await Promise.all([
        fetchProgress(selectedChild._id, newPeriod),
        fetchDailyStats(selectedChild._id, newPeriod === 'day' ? 1 : newPeriod === 'week' ? 7 : 30),
      ]);
    }
  };
  
  if (children.length === 0) {
    return (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="bg-white rounded-xl shadow-md p-12 text-center"
      >
        <Users className="w-16 h-16 text-gray-400 mx-auto mb-4" />
        <h3 className="text-2xl font-bold text-gray-800 mb-2">
          No Children Profiles Yet
        </h3>
        <p className="text-gray-600 mb-6">
          Create a child profile to start tracking progress
        </p>
      </motion.div>
    );
  }
  
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="space-y-6"
    >
      {/* Child Selector */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold text-gray-800 mb-4">Select Child</h3>
        <div className="flex gap-4 overflow-x-auto pb-2">
          {children.map((child) => (
            <button
              key={child._id}
              onClick={() => onSelectChild(child)}
              className={`flex items-center gap-3 px-6 py-3 rounded-lg border-2 transition whitespace-nowrap ${
                selectedChild?._id === child._id
                  ? 'border-purple-500 bg-purple-50'
                  : 'border-gray-200 hover:border-purple-300'
              }`}
            >
              {child.avatar ? (
                <img src={child.avatar} alt={child.name} className="w-10 h-10 rounded-full object-cover" />
              ) : (
                <div className="w-10 h-10 rounded-full bg-purple-200 flex items-center justify-center">
                  <User className="w-6 h-6 text-purple-600" />
                </div>
              )}
              <div className="text-left">
                <p className="font-semibold text-gray-800">{child.name}</p>
                <p className="text-sm text-gray-500">Age {child.age}</p>
              </div>
            </button>
          ))}
        </div>
      </div>
      
      {selectedChild && progressData && (
        <>
          {/* Period Selector */}
          <div className="flex justify-between items-center">
            <h2 className="text-2xl font-bold text-gray-800">
              Progress for {selectedChild.name}
            </h2>
            <div className="flex gap-2">
              {['day', 'week', 'month'].map((p) => (
                <button
                  key={p}
                  onClick={() => handlePeriodChange(p)}
                  className={`px-4 py-2 rounded-lg font-medium capitalize transition ${
                    period === p
                      ? 'bg-purple-600 text-white'
                      : 'bg-white text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  {p}
                </button>
              ))}
            </div>
          </div>
          
          {/* Stats Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <StatsCard
              title="Total Sessions"
              value={progressData.totalSessions || 0}
              icon={Trophy}
              color="purple"
            />
            <StatsCard
              title="Accuracy"
              value={`${progressData.accuracyPercent || 0}%`}
              icon={TrendingUp}
              color="green"
            />
            <StatsCard
              title="Avg Time"
              value={`${progressData.avgDurationSeconds || 0}s`}
              icon={Calendar}
              color="blue"
            />
            <StatsCard
              title="Top Game"
              value={progressData.topGame || 'N/A'}
              icon={BarChart3}
              color="orange"
              subtext="Best performing"
            />
          </div>
          
          {/* Charts */}
          {dailyStats && dailyStats.length > 0 && (
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <ChartCard
                title="Average Score Over Time"
                data={dailyStats.map(stat => ({
                  name: new Date(stat._id.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
                  avgScore: Math.round(stat.avgScore),
                }))}
                type="line"
                dataKey="avgScore"
                color="#8b5cf6"
              />
              <ChartCard
                title="Sessions Per Day"
                data={dailyStats.map(stat => ({
                  name: new Date(stat._id.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
                  sessions: stat.sessions,
                }))}
                type="bar"
                dataKey="sessions"
                color="#3b82f6"
              />
            </div>
          )}
          
          {/* Game Breakdown */}
          {progressData.gameBreakdown && Object.keys(progressData.gameBreakdown).length > 0 && (
            <div className="bg-white rounded-xl shadow-md p-6">
              <h3 className="text-xl font-semibold text-gray-800 mb-4">Game Performance</h3>
              <div className="space-y-4">
                {Object.entries(progressData.gameBreakdown).map(([game, stats]) => (
                  <div key={game} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div>
                      <h4 className="font-semibold text-gray-800 capitalize">{game}</h4>
                      <p className="text-sm text-gray-600">{stats.sessions} sessions</p>
                    </div>
                    <div className="text-right">
                      <p className="text-2xl font-bold text-purple-600">{Math.round(stats.avgScore)}</p>
                      <p className="text-sm text-gray-500">Avg Score</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </>
      )}
    </motion.div>
  );
};

// Placeholder components for other tabs (to be continued...)
const ChildrenTab = ({ children, onAddChild, showModal, setShowModal, loadData }) => {
  const [formData, setFormData] = useState({
    name: '',
    age: '',
    preferredDifficulty: 'easy',
  });
  const [avatarFile, setAvatarFile] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    
    try {
      const data = {
        ...formData,
        age: parseInt(formData.age),
      };
      
      if (avatarFile) {
        data.avatar = avatarFile;
      }
      
      await onAddChild(data);
      setShowModal(false);
      setFormData({ name: '', age: '', preferredDifficulty: 'easy' });
      setAvatarFile(null);
      await loadData();
    } catch (error) {
      console.error('Failed to add child:', error);
    } finally {
      setSubmitting(false);
    }
  };
  
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="space-y-6"
    >
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold text-gray-800">Manage Children</h2>
        <button
          onClick={() => setShowModal(true)}
          className="px-6 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition flex items-center gap-2"
        >
          <Plus className="w-5 h-5" />
          Add Child
        </button>
      </div>
      
      {/* Children Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {children.map((child) => (
          <div key={child._id} className="bg-white rounded-xl shadow-md p-6">
            <div className="flex items-center gap-4 mb-4">
              {child.avatar ? (
                <img src={child.avatar} alt={child.name} className="w-16 h-16 rounded-full object-cover" />
              ) : (
                <div className="w-16 h-16 rounded-full bg-purple-200 flex items-center justify-center">
                  <User className="w-8 h-8 text-purple-600" />
                </div>
              )}
              <div>
                <h3 className="font-bold text-gray-800 text-lg">{child.name}</h3>
                <p className="text-gray-600">Age {child.age}</p>
              </div>
            </div>
            <div className="space-y-2 text-sm">
              <p className="text-gray-600">
                <span className="font-medium">Difficulty:</span> <span className="capitalize">{child.preferredDifficulty}</span>
              </p>
              {child.notes && (
                <p className="text-gray-600">
                  <span className="font-medium">Notes:</span> {child.notes}
                </p>
              )}
            </div>
          </div>
        ))}
      </div>
      
      {/* Add Child Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full"
          >
            <h3 className="text-2xl font-bold text-gray-800 mb-6">Add New Child</h3>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Name</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                  placeholder="Child's name"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Age</label>
                <input
                  type="number"
                  value={formData.age}
                  onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                  required
                  min="1"
                  max="18"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                  placeholder="Age"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Starting Difficulty</label>
                <select
                  value={formData.preferredDifficulty}
                  onChange={(e) => setFormData({ ...formData, preferredDifficulty: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                >
                  <option value="easy">Easy</option>
                  <option value="medium">Medium</option>
                  <option value="hard">Hard</option>
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Avatar (Optional)</label>
                <input
                  type="file"
                  accept="image/*"
                  onChange={(e) => setAvatarFile(e.target.files[0])}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg"
                />
              </div>
              
              <div className="flex gap-3 mt-6">
                <button
                  type="submit"
                  disabled={submitting}
                  className="flex-1 px-6 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition disabled:opacity-50"
                >
                  {submitting ? 'Adding...' : 'Add Child'}
                </button>
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="flex-1 px-6 py-3 bg-gray-200 text-gray-800 rounded-lg font-semibold hover:bg-gray-300 transition"
                >
                  Cancel
                </button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </motion.div>
  );
};

const RemindersTab = ({ children, selectedChild, onSelectChild, reminders, onAddReminder, onUpdateReminder, onDeleteReminder }) => {
  const [showAddForm, setShowAddForm] = useState(false);
  const [currentTime, setCurrentTime] = useState('');
  const [formData, setFormData] = useState({
    type: 'breakfast',
    time: '08:00',
    title: '',
    message: '',
    daysOfWeek: [1, 2, 3, 4, 5], // Monday to Friday
  });
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });
  
  // Update current time every second
  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      const timeStr = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
      setCurrentTime(timeStr);
    };
    
    updateTime();
    const interval = setInterval(updateTime, 1000);
    return () => clearInterval(interval);
  }, []);
  
  // Helper to set time X minutes from now
  const setTimeFromNow = (minutes) => {
    const now = new Date();
    now.setMinutes(now.getMinutes() + minutes);
    const timeStr = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    const today = now.getDay();
    
    setFormData({
      ...formData,
      time: timeStr,
      daysOfWeek: [today], // Only today
    });
    
    setMessage({ 
      type: 'success', 
      text: `✅ Time set to ${timeStr} (${minutes} minute${minutes > 1 ? 's' : ''} from now) for today only!` 
    });
  };
  
  const mealTypes = [
    { value: 'breakfast', label: '🌅 Breakfast', defaultTime: '08:00', icon: '🥞' },
    { value: 'lunch', label: '☀️ Lunch', defaultTime: '12:00', icon: '🍱' },
    { value: 'dinner', label: '🌙 Dinner', defaultTime: '18:00', icon: '🍽️' },
    { value: 'snack', label: '🍎 Snack', defaultTime: '15:00', icon: '🍪' },
    { value: 'custom', label: '⏰ Custom', defaultTime: '10:00', icon: '🔔' },
  ];
  
  const weekDays = [
    { value: 0, label: 'Sun' },
    { value: 1, label: 'Mon' },
    { value: 2, label: 'Tue' },
    { value: 3, label: 'Wed' },
    { value: 4, label: 'Thu' },
    { value: 5, label: 'Fri' },
    { value: 6, label: 'Sat' },
  ];
  
  const handleTypeChange = (type) => {
    const mealType = mealTypes.find(m => m.value === type);
    setFormData({
      ...formData,
      type,
      time: mealType?.defaultTime || formData.time,
      title: formData.title || `${mealType?.label} Time!`,
    });
  };
  
  const handleAddReminder = async () => {
    if (!selectedChild) {
      setMessage({ type: 'error', text: 'Please select a child first' });
      return;
    }
    
    if (!formData.title) {
      setMessage({ type: 'error', text: 'Please enter a reminder title' });
      return;
    }
    
    setSubmitting(true);
    setMessage({ type: 'info', text: 'Creating reminder...' });
    
    try {
      await onAddReminder({
        childId: selectedChild._id,
        ...formData,
      });
      
      setMessage({ type: 'success', text: 'Reminder created successfully!' });
      setShowAddForm(false);
      setFormData({
        type: 'breakfast',
        time: '08:00',
        title: '',
        message: '',
        daysOfWeek: [1, 2, 3, 4, 5],
      });
    } catch (error) {
      console.error('Add reminder error:', error);
      setMessage({ type: 'error', text: error.response?.data?.message || 'Failed to create reminder' });
    } finally {
      setSubmitting(false);
    }
  };
  
  const handleToggleReminder = async (reminderId, currentState) => {
    try {
      await onUpdateReminder(reminderId, { enabled: !currentState });
      setMessage({ type: 'success', text: `Reminder ${!currentState ? 'enabled' : 'disabled'}` });
    } catch (error) {
      setMessage({ type: 'error', text: 'Failed to update reminder' });
    }
  };
  
  const handleDeleteReminder = async (reminderId) => {
    if (!confirm('Are you sure you want to delete this reminder?')) {
      return;
    }
    
    try {
      await onDeleteReminder(reminderId);
      setMessage({ type: 'success', text: 'Reminder deleted successfully' });
    } catch (error) {
      setMessage({ type: 'error', text: 'Failed to delete reminder' });
    }
  };
  
  const handleToggleDay = (day) => {
    const currentDays = formData.daysOfWeek || [];
    if (currentDays.includes(day)) {
      setFormData({ ...formData, daysOfWeek: currentDays.filter(d => d !== day) });
    } else {
      setFormData({ ...formData, daysOfWeek: [...currentDays, day].sort() });
    }
  };
  
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="space-y-6"
    >
      <h2 className="text-2xl font-bold text-gray-800">Meal & Activity Reminders</h2>
      
      {message.text && (
        <div className={`p-4 rounded-lg ${
          message.type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' :
          message.type === 'error' ? 'bg-red-50 text-red-800 border border-red-200' :
          'bg-blue-50 text-blue-800 border border-blue-200'
        }`}>
          <p className="font-medium">{message.text}</p>
        </div>
      )}
      
      {/* Child Selector */}
      {children.length > 0 && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Select Child</h3>
          <div className="flex gap-3 overflow-x-auto pb-2">
            {children.map((child) => (
              <button
                key={child._id}
                onClick={() => onSelectChild(child)}
                className={`flex items-center gap-2 px-4 py-2 rounded-lg border-2 transition whitespace-nowrap ${
                  selectedChild?._id === child._id
                    ? 'border-purple-500 bg-purple-50'
                    : 'border-gray-200 hover:border-purple-300'
                }`}
              >
                {child.avatar ? (
                  <img src={child.avatar} alt={child.name} className="w-8 h-8 rounded-full object-cover" />
                ) : (
                  <User className="w-8 h-8 text-purple-600" />
                )}
                <span className="font-medium">{child.name}</span>
              </button>
            ))}
          </div>
        </div>
      )}
      
      {/* Add Reminder Button */}
      {selectedChild && (
        <div className="flex justify-between items-center">
          <h3 className="text-xl font-semibold text-gray-800">
            Reminders for {selectedChild.name}
          </h3>
          <button
            onClick={() => setShowAddForm(!showAddForm)}
            className="px-6 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition flex items-center gap-2"
          >
            <Plus className="w-5 h-5" />
            {showAddForm ? 'Cancel' : 'Add Reminder'}
          </button>
        </div>
      )}
      
      {/* Add Reminder Form */}
      {showAddForm && selectedChild && (
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white rounded-xl shadow-md p-6"
        >
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Create New Reminder</h3>
          
          <div className="space-y-4">
            {/* Reminder Type */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Reminder Type</label>
              <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
                {mealTypes.map((meal) => (
                  <button
                    key={meal.value}
                    type="button"
                    onClick={() => handleTypeChange(meal.value)}
                    className={`p-4 rounded-lg border-2 transition text-center ${
                      formData.type === meal.value
                        ? 'border-purple-500 bg-purple-50'
                        : 'border-gray-200 hover:border-purple-300'
                    }`}
                  >
                    <div className="text-3xl mb-1">{meal.icon}</div>
                    <div className="text-sm font-medium">{meal.label}</div>
                  </button>
                ))}
              </div>
            </div>
            
            {/* Time */}
            <div>
              <div className="mb-2">
                <label className="block text-sm font-medium text-gray-700 mb-3">Time (HH:MM)</label>
                
                {/* Time Preview Helper */}
                <div className="bg-gradient-to-r from-blue-50 to-purple-50 border-2 border-blue-300 rounded-lg p-4 mb-3">
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <div className="text-xs text-gray-600 mb-1">Current Computer Time:</div>
                      <div className="text-2xl font-bold text-blue-600">{currentTime}</div>
                    </div>
                    <div className="text-right">
                      <div className="text-xs text-gray-600 mb-1">Quick Set:</div>
                      <div className="flex gap-2">
                        <button
                          type="button"
                          onClick={() => setTimeFromNow(1)}
                          className="px-3 py-1.5 bg-green-500 text-white text-xs rounded-lg hover:bg-green-600 transition font-medium"
                        >
                          +1 Min
                        </button>
                        <button
                          type="button"
                          onClick={() => setTimeFromNow(2)}
                          className="px-3 py-1.5 bg-blue-500 text-white text-xs rounded-lg hover:bg-blue-600 transition font-medium"
                        >
                          +2 Min
                        </button>
                        <button
                          type="button"
                          onClick={() => setTimeFromNow(5)}
                          className="px-3 py-1.5 bg-purple-500 text-white text-xs rounded-lg hover:bg-purple-600 transition font-medium"
                        >
                          +5 Min
                        </button>
                      </div>
                    </div>
                  </div>
                  <div className="grid grid-cols-3 gap-2 text-xs text-center">
                    <div className="bg-white rounded p-2">
                      <div className="text-gray-600">+1 min</div>
                      <div className="font-bold text-green-600">
                        {(() => {
                          const t = new Date();
                          t.setMinutes(t.getMinutes() + 1);
                          return `${String(t.getHours()).padStart(2, '0')}:${String(t.getMinutes()).padStart(2, '0')}`;
                        })()}
                      </div>
                    </div>
                    <div className="bg-white rounded p-2">
                      <div className="text-gray-600">+2 min</div>
                      <div className="font-bold text-blue-600">
                        {(() => {
                          const t = new Date();
                          t.setMinutes(t.getMinutes() + 2);
                          return `${String(t.getHours()).padStart(2, '0')}:${String(t.getMinutes()).padStart(2, '0')}`;
                        })()}
                      </div>
                    </div>
                    <div className="bg-white rounded p-2">
                      <div className="text-gray-600">+5 min</div>
                      <div className="font-bold text-purple-600">
                        {(() => {
                          const t = new Date();
                          t.setMinutes(t.getMinutes() + 5);
                          return `${String(t.getHours()).padStart(2, '0')}:${String(t.getMinutes()).padStart(2, '0')}`;
                        })()}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <input
                type="time"
                value={formData.time}
                onChange={(e) => setFormData({ ...formData, time: e.target.value })}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 text-lg"
              />
            </div>
            
            {/* Title */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Title</label>
              <input
                type="text"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                placeholder={`e.g., Time for ${formData.type}!`}
              />
            </div>
            
            {/* Message */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Message (Optional)</label>
              <textarea
                value={formData.message}
                onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                rows="2"
                placeholder={`e.g., It's time for a healthy ${formData.type}!`}
              />
            </div>
            
            {/* Days of Week */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Repeat On</label>
              <div className="flex gap-2">
                {weekDays.map((day) => (
                  <button
                    key={day.value}
                    type="button"
                    onClick={() => handleToggleDay(day.value)}
                    className={`flex-1 py-2 px-3 rounded-lg font-medium transition ${
                      formData.daysOfWeek?.includes(day.value)
                        ? 'bg-purple-600 text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }`}
                  >
                    {day.label}
                  </button>
                ))}
              </div>
              <p className="text-xs text-gray-500 mt-1">
                {formData.daysOfWeek?.length === 0 ? 'Reminder disabled - select at least one day' : 
                 formData.daysOfWeek?.length === 7 ? 'Every day' :
                 `${formData.daysOfWeek?.length || 0} days selected`}
              </p>
            </div>
            
            {/* Submit */}
            <div className="flex gap-3 pt-4">
              <button
                type="button"
                onClick={handleAddReminder}
                disabled={submitting || !formData.title}
                className="flex-1 px-6 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {submitting ? 'Creating...' : 'Create Reminder'}
              </button>
              <button
                type="button"
                onClick={() => setShowAddForm(false)}
                className="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg font-semibold hover:bg-gray-300 transition"
              >
                Cancel
              </button>
            </div>
          </div>
        </motion.div>
      )}
      
      {/* Debug Info */}
      {selectedChild && (
        <div className="bg-gradient-to-r from-green-50 to-blue-50 border-2 border-green-300 rounded-xl p-4">
          <div className="flex items-center justify-between">
            <div>
              <div className="font-bold text-gray-800 mb-1">🕐 System Time Check</div>
              <div className="text-sm text-gray-700">
                Current Time: <strong className="text-green-600 text-lg">{currentTime}</strong>
              </div>
              <div className="text-xs text-gray-600 mt-1">
                Day: {['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][new Date().getDay()]}
              </div>
            </div>
            <div className="text-right">
              <div className="text-xs text-gray-600">Reminder checks</div>
              <div className="text-lg font-bold text-blue-600">Every 10 sec</div>
            </div>
          </div>
        </div>
      )}
      
      {/* Current Reminders */}
      {selectedChild && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">
            Active Reminders ({reminders?.filter(r => r.enabled).length || 0})
          </h3>
          
          {!reminders || reminders.length === 0 ? (
            <div className="text-center py-12">
              <Bell className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <p className="text-gray-500">No reminders set yet</p>
              <p className="text-sm text-gray-400 mt-2">Click "Add Reminder" above to create one</p>
            </div>
          ) : (
            <div className="space-y-3">
              {reminders.map((reminder) => {
                const mealType = mealTypes.find(m => m.value === reminder.type);
                return (
                  <div
                    key={reminder._id}
                    className={`p-4 rounded-lg border-2 transition ${
                      reminder.enabled
                        ? 'border-purple-200 bg-purple-50'
                        : 'border-gray-200 bg-gray-50 opacity-60'
                    }`}
                  >
                    <div className="flex items-start justify-between">
                      <div className="flex items-start gap-4 flex-1">
                        <div className="text-4xl">{mealType?.icon || '🔔'}</div>
                        <div className="flex-1">
                          <h4 className="font-bold text-gray-800 text-lg mb-1">{reminder.title}</h4>
                          {reminder.message && (
                            <p className="text-sm text-gray-600 mb-2">{reminder.message}</p>
                          )}
                          <div className="flex flex-wrap gap-3 text-sm">
                            <span className={`px-3 py-1 bg-white rounded-full border font-medium ${
                              reminder.time === currentTime 
                                ? 'border-green-500 bg-green-50 text-green-700 animate-pulse' 
                                : 'border-purple-300 text-purple-700'
                            }`}>
                              ⏰ {reminder.time} {reminder.time === currentTime && '← NOW!'}
                            </span>
                            <span className="px-3 py-1 bg-white rounded-full border border-blue-300 text-blue-700 font-medium capitalize">
                              📅 {reminder.type}
                            </span>
                            {reminder.daysOfWeek && reminder.daysOfWeek.length > 0 && (
                              <span className="px-3 py-1 bg-white rounded-full border border-gray-300 text-gray-700">
                                {reminder.daysOfWeek.length === 7 ? 'Every day' :
                                 reminder.daysOfWeek.map(d => weekDays.find(wd => wd.value === d)?.label).join(', ')}
                              </span>
                            )}
                          </div>
                        </div>
                      </div>
                      
                      {/* Actions */}
                      <div className="flex gap-2 ml-4">
                        <button
                          onClick={() => handleToggleReminder(reminder._id, reminder.enabled)}
                          className={`px-4 py-2 rounded-lg font-medium transition ${
                            reminder.enabled
                              ? 'bg-yellow-500 text-white hover:bg-yellow-600'
                              : 'bg-green-500 text-white hover:bg-green-600'
                          }`}
                        >
                          {reminder.enabled ? 'Disable' : 'Enable'}
                        </button>
                        <button
                          onClick={() => handleDeleteReminder(reminder._id)}
                          className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition font-medium"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      )}
      
      {/* Info Box */}
      <div className="bg-blue-50 border border-blue-200 rounded-xl p-6">
        <h4 className="font-semibold text-blue-900 mb-2 flex items-center gap-2">
          <Bell className="w-5 h-5" />
          How Reminders Work
        </h4>
        <ul className="text-sm text-blue-800 space-y-1 list-disc list-inside">
          <li>Set specific times for meals and activities</li>
          <li>Reminders will show a popup notification at the scheduled time</li>
          <li>A pleasant sound will play to get the child's attention</li>
          <li>You can set different reminders for different days of the week</li>
          <li>Enable/disable reminders anytime without deleting them</li>
        </ul>
      </div>
      
      {!selectedChild && children.length > 0 && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-8 text-center">
          <Bell className="w-12 h-12 text-yellow-600 mx-auto mb-3" />
          <p className="text-yellow-800 font-medium">Please select a child above to manage their reminders</p>
        </div>
      )}
      
      {children.length === 0 && (
        <div className="bg-white rounded-xl shadow-md p-12 text-center">
          <Users className="w-16 h-16 text-gray-300 mx-auto mb-4" />
          <h3 className="text-xl font-bold text-gray-800 mb-2">No Children Yet</h3>
          <p className="text-gray-600 mb-4">Add a child profile first to create reminders</p>
        </div>
      )}
    </motion.div>
  );
};

const EmailTab = ({ parent, children, onUpdateParent, onSendReport }) => {
  const [caregiverEmail, setCaregiverEmail] = useState('');
  const [caregiverName, setCaregiverName] = useState('');
  const [reportFrequency, setReportFrequency] = useState(parent?.reportFrequency || 'weekly');
  const [sending, setSending] = useState(false);
  const [adding, setAdding] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });
  const [currentParent, setCurrentParent] = useState(parent);
  
  // Refresh parent data when tab loads
  useEffect(() => {
    const refreshParentData = async () => {
      try {
        console.log('🔄 Refreshing parent data from database...');
        const response = await axios.get('/auth/me');
        const freshParent = response.data.data;
        console.log('✅ Fresh parent data:', freshParent);
        console.log('Caregiver emails in DB:', freshParent.caregiverEmails);
        setCurrentParent(freshParent);
      } catch (error) {
        console.error('Failed to refresh parent data:', error);
      }
    };
    refreshParentData();
  }, []);
  
  const handleAddCaregiver = async () => {
    console.log('🔵 Add Caregiver button clicked!');
    console.log('Name:', caregiverName);
    console.log('Email:', caregiverEmail);
    console.log('Parent from props:', parent);
    console.log('Current parent state:', currentParent);
    
    if (!caregiverEmail || !caregiverName) {
      console.log('❌ Missing name or email');
      setMessage({ type: 'error', text: 'Please fill in both name and email' });
      return;
    }
    
    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(caregiverEmail)) {
      console.log('❌ Invalid email format');
      setMessage({ type: 'error', text: 'Please enter a valid email address' });
      return;
    }
    
    const currentEmails = currentParent?.caregiverEmails || [];
    console.log('Current emails from state:', currentEmails);
    
    // Check if email already exists
    if (currentEmails.some(c => c.email === caregiverEmail)) {
      console.log('❌ Email already exists');
      setMessage({ type: 'error', text: 'This email is already added' });
      return;
    }
    
    setAdding(true);
    setMessage({ type: 'info', text: 'Adding caregiver...' });
    console.log('🔄 Starting to add caregiver...');
    
    try {
      const updatedEmails = [...currentEmails, { email: caregiverEmail, name: caregiverName }];
      console.log('Updated emails:', updatedEmails);
      console.log('Calling onUpdateParent...');
      
      const result = await onUpdateParent({
        caregiverEmails: updatedEmails,
      });
      
      console.log('✅ onUpdateParent result:', result);
      
      // Update local state with fresh data
      setCurrentParent(result);
      
      setMessage({ type: 'success', text: 'Caregiver email added successfully!' });
      setCaregiverEmail('');
      setCaregiverName('');
    } catch (error) {
      console.error('❌ Add caregiver error:', error);
      console.error('Error response:', error.response);
      console.error('Error message:', error.message);
      setMessage({ type: 'error', text: error.response?.data?.message || error.message || 'Failed to add caregiver email' });
    } finally {
      setAdding(false);
      console.log('🔵 Add caregiver finished');
    }
  };
  
  const handleRemoveCaregiver = async (email) => {
    setMessage({ type: 'info', text: 'Removing...' });
    const updatedEmails = (currentParent?.caregiverEmails || []).filter(c => c.email !== email);
    try {
      const result = await onUpdateParent({
        caregiverEmails: updatedEmails,
      });
      setCurrentParent(result);
      setMessage({ type: 'success', text: 'Caregiver email removed' });
    } catch (error) {
      console.error('Remove caregiver error:', error);
      setMessage({ type: 'error', text: error.response?.data?.message || 'Failed to remove caregiver email' });
    }
  };
  
  const handleUpdateFrequency = async (frequency) => {
    setReportFrequency(frequency);
    setMessage({ type: 'info', text: 'Updating...' });
    try {
      await onUpdateParent({ reportFrequency: frequency });
      setMessage({ type: 'success', text: 'Report frequency updated!' });
    } catch (error) {
      console.error('Update frequency error:', error);
      setMessage({ type: 'error', text: error.response?.data?.message || 'Failed to update frequency' });
    }
  };
  
  const handleSendTestReport = async (childId, childName) => {
    setSending(true);
    setMessage({ type: 'info', text: 'Sending report...' });
    
    try {
      const result = await onSendReport(childId);
      setMessage({ 
        type: 'success', 
        text: `Report sent successfully to ${result.data?.length || 0} caregiver(s)!` 
      });
    } catch (error) {
      setMessage({ 
        type: 'error', 
        text: error.response?.data?.message || 'Failed to send report. Make sure caregiver emails are configured.' 
      });
    } finally {
      setSending(false);
    }
  };
  
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="space-y-6"
    >
      <h2 className="text-2xl font-bold text-gray-800">Email Reports Configuration</h2>
      
      {/* Message Alert */}
      {message.text && (
        <div className={`p-4 rounded-lg ${
          message.type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' :
          message.type === 'error' ? 'bg-red-50 text-red-800 border border-red-200' :
          'bg-blue-50 text-blue-800 border border-blue-200'
        }`}>
          <p className="font-medium">{message.text}</p>
        </div>
      )}
      
      {/* Report Frequency */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold text-gray-800 mb-4">Report Frequency</h3>
        <p className="text-sm text-gray-600 mb-4">
          Choose how often automated progress reports are sent to caregivers
        </p>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {['daily', 'weekly', 'monthly', 'none'].map((freq) => (
            <button
              key={freq}
              onClick={() => handleUpdateFrequency(freq)}
              className={`px-4 py-3 rounded-lg font-medium transition capitalize ${
                reportFrequency === freq
                  ? 'bg-purple-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              {freq}
            </button>
          ))}
        </div>
      </div>
      
      {/* Add Caregiver */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold text-gray-800 mb-4">Add Caregiver Email</h3>
        <p className="text-sm text-gray-600 mb-4">
          Add email addresses to receive automated progress reports
        </p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Caregiver Name</label>
            <input
              type="text"
              value={caregiverName}
              onChange={(e) => {
                console.log('Name changed:', e.target.value);
                setCaregiverName(e.target.value);
              }}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
              placeholder="e.g., Grandma, Therapist, Teacher"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
            <input
              type="email"
              value={caregiverEmail}
              onChange={(e) => {
                console.log('Email changed:', e.target.value);
                setCaregiverEmail(e.target.value);
              }}
              onKeyPress={(e) => {
                if (e.key === 'Enter') {
                  e.preventDefault();
                  handleAddCaregiver();
                }
              }}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
              placeholder="caregiver@example.com"
            />
          </div>
        </div>
        <button
          type="button"
          onClick={(e) => {
            e.preventDefault();
            console.log('🟢 Button physically clicked!');
            handleAddCaregiver();
          }}
          disabled={adding || !caregiverEmail || !caregiverName}
          className="px-6 py-3 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {adding ? 'Adding...' : 'Add Caregiver'}
        </button>
      </div>
      
      {/* Current Caregivers */}
      <div className="bg-white rounded-xl shadow-md p-6">
        <h3 className="text-lg font-semibold text-gray-800 mb-4">
          Caregiver Emails ({currentParent?.caregiverEmails?.length || 0})
        </h3>
        {!currentParent?.caregiverEmails || currentParent.caregiverEmails.length === 0 ? (
          <p className="text-gray-500 text-center py-8">
            No caregiver emails added yet. Add one above to start receiving reports.
          </p>
        ) : (
          <div className="space-y-3">
            {currentParent.caregiverEmails.map((caregiver, index) => (
              <div
                key={index}
                className="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
              >
                <div>
                  <p className="font-medium text-gray-800">{caregiver.name || 'Caregiver'}</p>
                  <p className="text-sm text-gray-600">{caregiver.email}</p>
                </div>
                <button
                  onClick={() => handleRemoveCaregiver(caregiver.email)}
                  className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition text-sm font-medium"
                >
                  Remove
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
      
      {/* Send Test Reports */}
      {children.length > 0 && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Send Test Report</h3>
          <p className="text-sm text-gray-600 mb-4">
            Send an instant progress report for any child to test the email system
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {children.map((child) => (
              <div
                key={child._id}
                className="p-4 border-2 border-gray-200 rounded-lg hover:border-purple-400 transition"
              >
                <div className="flex items-center gap-3 mb-3">
                  {child.avatar ? (
                    <img src={child.avatar} alt={child.name} className="w-12 h-12 rounded-full object-cover" />
                  ) : (
                    <div className="w-12 h-12 rounded-full bg-purple-200 flex items-center justify-center">
                      <span className="text-xl">👦</span>
                    </div>
                  )}
                  <div>
                    <p className="font-semibold text-gray-800">{child.name}</p>
                    <p className="text-xs text-gray-500">Age {child.age}</p>
                  </div>
                </div>
                <button
                  onClick={() => handleSendTestReport(child._id, child.name)}
                  disabled={sending || !currentParent?.caregiverEmails?.length}
                  className="w-full px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition disabled:opacity-50 disabled:cursor-not-allowed text-sm font-medium"
                >
                  {sending ? 'Sending...' : `Send Report for ${child.name}`}
                </button>
              </div>
            ))}
          </div>
          {!currentParent?.caregiverEmails?.length && (
            <p className="text-sm text-orange-600 mt-4">
              ⚠️ Add at least one caregiver email above before sending reports
            </p>
          )}
        </div>
      )}
      
      {/* Info Box */}
      <div className="bg-blue-50 border border-blue-200 rounded-xl p-6">
        <h4 className="font-semibold text-blue-900 mb-2 flex items-center gap-2">
          <Mail className="w-5 h-5" />
          How Email Reports Work
        </h4>
        <ul className="text-sm text-blue-800 space-y-1 list-disc list-inside">
          <li>Reports include progress charts, statistics, and AI-generated insights</li>
          <li>Automated reports are sent based on your chosen frequency (daily/weekly/monthly)</li>
          <li>You can also send instant test reports at any time using the button above</li>
          <li>Make sure your SMTP settings in backend/.env are configured correctly</li>
        </ul>
      </div>
    </motion.div>
  );
};

const AITab = ({ children, selectedChild, onSelectChild, aiRecommendation, aiTips, onFetchRecommendation, onFetchTip }) => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  const handleGetRecommendation = async () => {
    if (!selectedChild) {
      setError('Please select a child first');
      return;
    }
    
    setLoading(true);
    setError(null);
    
    try {
      await onFetchRecommendation(selectedChild._id);
    } catch (err) {
      setError(err.response?.data?.message || err.message || 'Failed to get AI recommendation');
    } finally {
      setLoading(false);
    }
  };
  
  const handleGetTip = async () => {
    if (!selectedChild) {
      setError('Please select a child first');
      return;
    }
    
    setLoading(true);
    setError(null);
    
    try {
      await onFetchTip(selectedChild._id);
    } catch (err) {
      setError(err.response?.data?.message || err.message || 'Failed to get parent tip');
    } finally {
      setLoading(false);
    }
  };
  
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="space-y-6"
    >
      <div className="bg-gradient-to-r from-purple-50 to-blue-50 rounded-xl shadow-md p-8 border-2 border-purple-200">
        <div className="flex items-start gap-4">
          <Sparkles className="w-12 h-12 text-purple-600 flex-shrink-0" />
          <div>
            <h3 className="text-2xl font-bold text-gray-800 mb-2">AI-Powered Insights</h3>
            <p className="text-gray-700 mb-4">
              Get personalized recommendations, adaptive difficulty suggestions, and parenting tips powered by AI.
            </p>
            
            <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-4">
              <div className="flex">
                <div className="flex-shrink-0">
                  <svg className="h-5 w-5 text-yellow-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                  </svg>
                </div>
                <div className="ml-3">
                  <p className="text-sm text-yellow-700">
                    <strong>OpenAI API Not Configured</strong> - AI features are currently disabled. The app works perfectly without AI, but you can enable advanced features by adding an OpenAI API key.
                  </p>
                </div>
              </div>
            </div>
            
            <details className="bg-white rounded-lg p-4 mb-4">
              <summary className="font-semibold text-purple-700 cursor-pointer hover:text-purple-800">
                📚 How to Enable AI Features (Optional)
              </summary>
              <div className="mt-3 text-sm text-gray-700 space-y-2">
                <p><strong>Step 1:</strong> Go to <a href="https://platform.openai.com/api-keys" target="_blank" rel="noopener noreferrer" className="text-blue-600 underline">OpenAI API Keys</a></p>
                <p><strong>Step 2:</strong> Create an account or sign in</p>
                <p><strong>Step 3:</strong> Click "Create new secret key"</p>
                <p><strong>Step 4:</strong> Copy the key (starts with "sk-")</p>
                <p><strong>Step 5:</strong> Add to <code className="bg-gray-100 px-2 py-1 rounded">backend/.env</code>:</p>
                <pre className="bg-gray-900 text-green-400 p-3 rounded mt-2 overflow-x-auto">
OPENAI_API_KEY=sk-your-actual-key-here
                </pre>
                <p><strong>Step 6:</strong> Restart the backend server</p>
                <p className="text-orange-600 mt-2">⚠️ Note: OpenAI API is a paid service. Check pricing at <a href="https://openai.com/pricing" target="_blank" rel="noopener noreferrer" className="underline">openai.com/pricing</a></p>
              </div>
            </details>
            
            <div className="bg-blue-50 rounded-lg p-4">
              <h4 className="font-semibold text-blue-900 mb-2">What AI Features Provide:</h4>
              <ul className="text-sm text-blue-800 space-y-1 list-disc list-inside">
                <li><strong>Adaptive Difficulty:</strong> AI analyzes game performance and recommends the best difficulty level</li>
                <li><strong>Parent Tips:</strong> Personalized guidance based on your child's progress patterns</li>
                <li><strong>Motivational Messages:</strong> Encouraging words tailored to your child</li>
                <li><strong>Song Generation:</strong> Custom meal-time songs with AI-generated lyrics</li>
                <li><strong>Email Insights:</strong> AI-enhanced suggestions in progress reports</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      
      {/* Test AI Features (if configured) */}
      {children.length > 0 && (
        <div className="bg-white rounded-xl shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-800 mb-4">Test AI Features</h3>
          <p className="text-sm text-gray-600 mb-4">
            Try the AI features below. If OpenAI is not configured, you'll see an error message.
          </p>
          
          {/* Child Selector */}
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-2">Select Child:</label>
            <div className="flex gap-3 overflow-x-auto pb-2">
              {children.map((child) => (
                <button
                  key={child._id}
                  onClick={() => onSelectChild(child)}
                  className={`px-4 py-2 rounded-lg border-2 transition whitespace-nowrap ${
                    selectedChild?._id === child._id
                      ? 'border-purple-500 bg-purple-50'
                      : 'border-gray-200 hover:border-purple-300'
                  }`}
                >
                  {child.name}
                </button>
              ))}
            </div>
          </div>
          
          {error && (
            <div className="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
              {error}
            </div>
          )}
          
          {/* AI Actions */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="border-2 border-gray-200 rounded-lg p-4">
              <h4 className="font-semibold text-gray-800 mb-2">Get Difficulty Recommendation</h4>
              <p className="text-sm text-gray-600 mb-3">AI analyzes recent game sessions and suggests the best difficulty level</p>
              <button
                onClick={handleGetRecommendation}
                disabled={loading || !selectedChild}
                className="w-full px-4 py-2 bg-purple-600 text-white rounded-lg font-medium hover:bg-purple-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? 'Generating...' : 'Get AI Recommendation'}
              </button>
            </div>
            
            <div className="border-2 border-gray-200 rounded-lg p-4">
              <h4 className="font-semibold text-gray-800 mb-2">Get Parent Tip</h4>
              <p className="text-sm text-gray-600 mb-3">Receive personalized guidance based on your child's progress</p>
              <button
                onClick={handleGetTip}
                disabled={loading || !selectedChild}
                className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {loading ? 'Generating...' : 'Get Parent Tip'}
              </button>
            </div>
          </div>
          
          {/* AI Results */}
          {aiRecommendation && (
            <div className="mt-6 bg-purple-50 border border-purple-200 rounded-lg p-4">
              <h4 className="font-semibold text-purple-900 mb-2 flex items-center gap-2">
                <Sparkles className="w-5 h-5" />
                AI Recommendation
              </h4>
              <div className="text-sm text-purple-800 space-y-2">
                <p><strong>Suggested Level:</strong> <span className="capitalize">{aiRecommendation.recommendation}</span></p>
                <p><strong>Reason:</strong> {aiRecommendation.reason}</p>
                <p><strong>Motivation:</strong> {aiRecommendation.motivation}</p>
                {aiRecommendation.tips && <p><strong>Tip:</strong> {aiRecommendation.tips}</p>}
              </div>
            </div>
          )}
          
          {aiTips && aiTips.length > 0 && (
            <div className="mt-6 space-y-3">
              <h4 className="font-semibold text-gray-800">Parent Tips:</h4>
              {aiTips.map((tip, index) => (
                <div key={index} className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                  <p className="text-sm text-blue-800">{tip.tip}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
      
      {/* App works without AI note */}
      <div className="bg-green-50 border border-green-200 rounded-xl p-6">
        <h4 className="font-semibold text-green-900 mb-2 flex items-center gap-2">
          <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
          </svg>
          Your App Works Perfectly Without AI!
        </h4>
        <p className="text-sm text-green-800">
          All core features (games, progress tracking, email reports, reminders) work completely without OpenAI. 
          AI features are an optional enhancement that provide additional insights and personalization.
        </p>
      </div>
    </motion.div>
  );
};

export default ParentDashboard;

