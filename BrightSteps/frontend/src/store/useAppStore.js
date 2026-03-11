import { create } from 'zustand';
import axios from '../api/axiosInstance';

export const useAppStore = create((set, get) => ({
  // Authentication state
  parent: JSON.parse(localStorage.getItem('brightsteps_parent') || 'null'),
  token: localStorage.getItem('brightsteps_token') || null,
  isAuthenticated: !!localStorage.getItem('brightsteps_token'),
  
  // Children state
  children: [],
  currentChild: JSON.parse(localStorage.getItem('brightsteps_currentChild') || 'null'),
  
  // Progress data
  progressData: {},
  gameRecords: [],
  dailyStats: [],
  
  // Reminders
  reminders: [],
  activeReminder: null,
  
  // AI
  aiTips: [],
  aiRecommendation: null,
  
  // UI state
  loading: false,
  error: null,
  
  // Auth actions
  setAuth: (parent, token) => {
    localStorage.setItem('brightsteps_parent', JSON.stringify(parent));
    localStorage.setItem('brightsteps_token', token);
    set({ 
      parent, 
      token, 
      isAuthenticated: true,
      error: null,
    });
  },
  
  logout: () => {
    localStorage.removeItem('brightsteps_parent');
    localStorage.removeItem('brightsteps_token');
    localStorage.removeItem('brightsteps_currentChild');
    set({ 
      parent: null, 
      token: null, 
      isAuthenticated: false,
      children: [],
      currentChild: null,
      progressData: {},
      gameRecords: [],
      reminders: [],
      aiTips: [],
    });
  },
  
  updateParent: async (updates) => {
    try {
      // Save to backend database
      const response = await axios.put('/auth/me', updates);
      const updatedParent = response.data.data;
      
      // Update localStorage and state
      localStorage.setItem('brightsteps_parent', JSON.stringify(updatedParent));
      set({ parent: updatedParent });
      
      return updatedParent;
    } catch (error) {
      console.error('Failed to update parent:', error);
      set({ error: error.response?.data?.message || 'Failed to update profile' });
      throw error;
    }
  },
  
  // Children actions
  setChildren: (children) => set({ children }),
  
  setCurrentChild: (child) => {
    localStorage.setItem('brightsteps_currentChild', JSON.stringify(child));
    set({ currentChild: child });
  },
  
  fetchChildren: async () => {
    try {
      set({ loading: true, error: null });
      const response = await axios.get('/children');
      set({ children: response.data.data, loading: false });
      return response.data.data;
    } catch (error) {
      set({ 
        error: error.response?.data?.message || 'Failed to fetch children',
        loading: false,
      });
      throw error;
    }
  },
  
  createChild: async (childData) => {
    try {
      set({ loading: true, error: null });
      const formData = new FormData();
      Object.keys(childData).forEach(key => {
        if (key === 'interests') {
          formData.append(key, JSON.stringify(childData[key]));
        } else {
          formData.append(key, childData[key]);
        }
      });
      
      const response = await axios.post('/children', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      
      const newChild = response.data.data;
      set({ 
        children: [...get().children, newChild],
        loading: false,
      });
      return newChild;
    } catch (error) {
      set({ 
        error: error.response?.data?.message || 'Failed to create child',
        loading: false,
      });
      throw error;
    }
  },
  
  // Game actions
  saveGameRecord: async (recordData) => {
    try {
      const response = await axios.post('/games/record', recordData);
      set({ 
        gameRecords: [response.data.data, ...get().gameRecords],
      });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to save game record' });
      throw error;
    }
  },
  
  fetchProgress: async (childId, period = 'week') => {
    try {
      set({ loading: true, error: null });
      const response = await axios.get(`/games/progress/${childId}?period=${period}`);
      set({ 
        progressData: response.data.data,
        loading: false,
      });
      return response.data.data;
    } catch (error) {
      set({ 
        error: error.response?.data?.message || 'Failed to fetch progress',
        loading: false,
      });
      throw error;
    }
  },
  
  fetchGameRecords: async (childId, filters = {}) => {
    try {
      set({ loading: true, error: null });
      const params = new URLSearchParams(filters).toString();
      const response = await axios.get(`/games/records/${childId}?${params}`);
      set({ 
        gameRecords: response.data.data,
        loading: false,
      });
      return response.data.data;
    } catch (error) {
      set({ 
        error: error.response?.data?.message || 'Failed to fetch game records',
        loading: false,
      });
      throw error;
    }
  },
  
  fetchDailyStats: async (childId, days = 7) => {
    try {
      const response = await axios.get(`/games/daily-stats/${childId}?days=${days}`);
      set({ dailyStats: response.data.data });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to fetch daily stats' });
      throw error;
    }
  },
  
  // Reminder actions
  fetchReminders: async (childId) => {
    try {
      const response = await axios.get(`/reminders/${childId}`);
      set({ reminders: response.data.data });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to fetch reminders' });
      throw error;
    }
  },
  
  addReminder: async (reminderData) => {
    try {
      const response = await axios.post('/reminders', reminderData);
      set({ 
        reminders: [...get().reminders, response.data.data],
      });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to add reminder' });
      throw error;
    }
  },
  
  updateReminder: async (id, updates) => {
    try {
      const response = await axios.put(`/reminders/${id}`, updates);
      set({
        reminders: get().reminders.map(r => 
          r._id === id ? response.data.data : r
        ),
      });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to update reminder' });
      throw error;
    }
  },
  
  deleteReminder: async (id) => {
    try {
      await axios.delete(`/reminders/${id}`);
      set({
        reminders: get().reminders.filter(r => r._id !== id),
      });
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to delete reminder' });
      throw error;
    }
  },
  
  setActiveReminder: (reminder) => set({ activeReminder: reminder }),
  
  // AI actions
  fetchAIRecommendation: async (childId) => {
    try {
      set({ loading: true, error: null });
      const response = await axios.post('/ai/adapt', { childId });
      set({ 
        aiRecommendation: response.data.data,
        loading: false,
      });
      return response.data.data;
    } catch (error) {
      set({ 
        error: error.response?.data?.message || 'Failed to fetch AI recommendation',
        loading: false,
      });
      throw error;
    }
  },
  
  generateSongLyrics: async (type, childName) => {
    try {
      const response = await axios.post('/ai/song', { type, childName });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to generate song' });
      throw error;
    }
  },
  
  generateMotivation: async (childId, context) => {
    try {
      const response = await axios.post('/ai/motivate', { childId, context });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to generate motivation' });
      throw error;
    }
  },
  
  fetchParentTip: async (childId, period = 'week') => {
    try {
      const response = await axios.post('/ai/parent-tip', { childId, period });
      set({
        aiTips: [response.data.data, ...get().aiTips],
      });
      return response.data.data;
    } catch (error) {
      set({ error: error.response?.data?.message || 'Failed to fetch parent tip' });
      throw error;
    }
  },
  
  // Report actions
  sendReport: async (childId) => {
    try {
      set({ loading: true, error: null });
      const response = await axios.post('/report/send', { childId });
      set({ loading: false });
      return response.data;
    } catch (error) {
      set({ 
        error: error.response?.data?.message || 'Failed to send report',
        loading: false,
      });
      throw error;
    }
  },
  
  // Utility actions
  clearError: () => set({ error: null }),
}));

export default useAppStore;

