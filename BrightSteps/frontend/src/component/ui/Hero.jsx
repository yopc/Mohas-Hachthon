import React from 'react'

const Hero = () => {
  return (
    <section className='relative h-[70vh] min-h-[500px] overflow-hidden bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-900 dark:to-blue-900/50'> 
      <div className='absolute inset-0 overflow-hidden'>
        {/* Decorative elements */}
        <div className="absolute top-20 -left-20 w-96 h-96 bg-blue-200/20 dark:bg-indigo-700/20 rounded-full filter blur-3xl"></div>
        <div className="absolute bottom-20 -right-20 w-80 h-80 bg-indigo-200/20 dark:bg-blue-800/20 rounded-full filter blur-3xl"></div>
        
        {/* Floating learning elements */}
        <div className="absolute top-1/4 right-10 w-16 h-16 bg-yellow-400 rounded-lg transform rotate-12 shadow-lg"></div>
        <div className="absolute top-1/3 left-20 w-12 h-12 bg-green-400 rounded-full shadow-lg"></div>
        <div className="absolute bottom-1/4 left-1/3 w-14 h-14 bg-blue-400 rounded-lg transform -rotate-12 shadow-lg"></div>
      </div>

      <div className='relative container mx-auto px-4 h-full flex items-center max-w-7xl'>
        <div className='max-w-2xl'>
          <h1 className='text-4xl md:text-5xl lg:text-6xl font-bold mb-6 leading-tight text-gray-900 dark:text-white'>
            Empower Your <br/>
            <span className='block bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent mt-2'>
              Learning Journey
            </span>
          </h1>
          <p className="text-lg md:text-xl mb-8 text-gray-700 dark:text-gray-300 leading-relaxed max-w-xl">
            Access world-class courses, tutorials, and resources to advance your skills. 
            Learn at your own pace with expert instructors.
          </p>
          <div className='flex flex-col sm:flex-row gap-4'>
            <button className='px-6 py-3 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-medium rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1'>
              Explore Courses
            </button>
            <button className='px-6 py-3 bg-white dark:bg-gray-800 text-blue-600 dark:text-blue-400 font-medium rounded-lg border border-blue-200 dark:border-gray-700 shadow hover:shadow-lg transition-all'>
              View Free Resources
            </button>
          </div>
        </div>
      </div>
    </section>
  )
}

export default Hero
