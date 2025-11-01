import { Moon, Search, ShoppingCart, Sun, User } from 'lucide-react'
import React, { useState } from 'react'

const Head = () => {
  const [isDarkMode , setIsDarkMode] = useState(false)
  const toggleDarkMode = () => {
    setIsDarkMode(!isDarkMode)
   document.documentElement.classList.toggle('dark')
 }

  return (
    <header className='sticky z-50 top-0 bg-white/90 dark:bg-black/80 backdrop:blur  shadow-md'>
      <div className='flex container mx-auto items-center justify-between h-16 px-4'>
        <h1 className='text-2xl font-bold text-blue-600'>Style 
        <span className='text-blue-950 dark:text-white'>Hub</span>
      </h1>

     <div className='space-x-4 text-gray-900 dark:text-white '>
      <button className='hover:text-blue-500'>Home</button>
      <button  className='hover:text-blue-500'>Men</button>
      <button  className='hover:text-blue-500'>Women</button>
      <button  className='hover:text-blue-500'>Electronics</button>
      <button  className='hover:text-blue-500'>Sell</button>
     </div>

      <div className='space-x-4 flex items-center'>
             <div className='flex items-center bg-gray-200  rounded-full px-2'>
      <Search size={16} className='text-gray-400 mr-2'/>
      <input type="text" 
      placeholder='Search'
      className='outline-none bg-transparent '/>
      </div>
      <button className='relative'>
        <ShoppingCart size={20} className='dark:text-gray-400'/>
        <span className='absolute -top-2 -right-2 bg-blue-700 text-white rounded-full text-xs flex items-center justify-center w-4 h-4'>3</span>
      </button>
      <button
      onClick={toggleDarkMode}
      className=' hover:bg-gray-200 p-2  rounded-full'>
        {isDarkMode ? 
       <Moon className='text-gray-400 '/>
        :
         <Sun className='text-yellow-200'/>
        
        
      }
      </button>
     <User className='dark:text-gray-400'/>
      </div>
      </div>
    </header>
  )
}

export default Head