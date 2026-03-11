import React, { useState } from 'react';
import { User, Menu, X, Search, Sun, Moon, BookOpen, Video, Bookmark, LogIn, LogOut } from 'lucide-react';

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isDarkMode, setIsDarkMode] = useState(false);

  const toggleMenu = () => setIsMenuOpen(!isMenuOpen);
  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
    document.documentElement.classList.toggle('dark');
  };

  return (
    <header className='sticky top-0 z-50 w-full border-b bg-white/90 dark:bg-gray-900/90 backdrop-blur'>
      <div className='container mx-auto px-4 flex items-center justify-between h-16'>
        {/* Logo */}
        <div className='text-2xl font-bold text-blue-600 cursor-pointer select-none'>
          Easy<span className='text-gray-800 dark:text-gray-100'>Study</span>
        </div>

        {/* Desktop Navigation */}
        <nav className='hidden md:flex items-center space-x-8'>
          {[
            { name: 'Courses', icon: <BookOpen size={16} className="mr-1" /> },
            { name: 'Tutorials', icon: <Video size={16} className="mr-1" /> },
            { name: 'Resources', icon: <Bookmark size={16} className="mr-1" /> },
            { name: 'About', icon: null },
          ].map((item) => (
            <button
              key={item.name}
              className='flex items-center text-sm font-medium text-gray-700 dark:text-gray-200 hover:text-blue-600 transition-colors'
            >
              {item.icon}
              {item.name}
            </button>
          ))}
        </nav>

        {/* Right Icons */}
        <div className='flex items-center space-x-4'>
          {/* Search */}
          <div className='hidden md:flex items-center bg-gray-100 dark:bg-gray-800 rounded-full px-3 py-1'>
            <Search size={16} className='text-gray-500 mr-2' />
            <input
              type='text'
              placeholder='Search...'
              className='bg-transparent outline-none text-sm w-32 md:w-48 text-gray-800 dark:text-gray-100 placeholder-gray-400'
            />
          </div>

          {/* Theme Toggle */}
          <button
            onClick={toggleTheme}
            className='p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition'
            title='Toggle theme'
          >
            {isDarkMode ? (
              <Sun size={18} className='text-yellow-400' />
            ) : (
              <Moon size={18} className='text-gray-700 dark:text-gray-200' />
            )}
          </button>

          {/* Cart */}
          <button className='flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-full transition'>
            <LogIn size={16} className='mr-1'/>
            <span className='text-sm'>Login</span>
          </button>
          
          <button className='flex items-center px-4 py-2 bg-gray-800 dark:bg-gray-700 text-white rounded-full transition'>
            <LogOut size={16} className='mr-1'/>
            <span className='text-sm'>Register</span>
          </button>

          {/* Profile */}
          <button className='p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition'>
            <User size={20} className='dark:text-gray-200'/>
          </button>

          {/* Mobile Menu Button */}
          <button
            className='md:hidden p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition'
            onClick={toggleMenu}
          >
            {isMenuOpen ? <X size={20}  className='dark:text-gray-200'/> : <Menu size={20}  className='dark:text-gray-200'/>}
          </button>
        </div>
      </div>

      {/* Mobile Dropdown Menu */}
        {isMenuOpen && (
        <nav className='md:hidden bg-white dark:bg-gray-900 border-t'>
          <ul className='flex flex-col items-center py-4 space-y-4'>
            {[
              { name: 'Courses', icon: <BookOpen size={16} className="mr-2" /> },
              { name: 'Tutorials', icon: <Video size={16} className="mr-2" /> },
              { name: 'Resources', icon: <Bookmark size={16} className="mr-2" /> },
              { name: 'About', icon: null },
            ].map((item) => (
              <li key={item.name} className='w-full text-center'>
                <button className='flex items-center justify-center w-full py-2 text-gray-700 dark:text-gray-200 text-sm font-medium hover:text-blue-600 transition-colors'>
                  {item.icon}
                  {item.name}
                </button>
              </li>
            ))}
            <div className='mt-2 w-full px-4'>
              <div className='flex items-center bg-gray-100 dark:bg-gray-800 rounded-full px-3 py-2'>
                <Search size={16} className='text-gray-500 mr-2' />
                <input
                  type='text'
                  placeholder='Search courses...'
                  className='bg-transparent outline-none text-sm w-full text-gray-800 dark:text-gray-100 placeholder-gray-400'
                />
              </div>
            </div>
          </ul>
        </nav>
      )}
    </header>
  );
};

export default Header;
