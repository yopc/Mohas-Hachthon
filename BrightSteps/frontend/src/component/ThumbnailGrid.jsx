import React from "react";

const thumbnails = [
  {
    id: 1,
    title: "AI Body Scanner",
    desc: "Revolutionize fashion with smart AI-powered virtual try-ons.",
    img: "https://images.unsplash.com/photo-1626785774573-4b799315345d?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: 2,
    title: "Cloud Collaboration",
    desc: "Empower your teams with secure, real-time cloud solutions.",
    img: "https://images.unsplash.com/photo-1603791440384-56cd371ee9a7?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: 3,
    title: "Smart Analytics",
    desc: "Turn your data into powerful insights and business growth.",
    img: "https://images.unsplash.com/photo-1556157382-97eda2d62296?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: 4,
    title: "Next-Gen UI Design",
    desc: "Create beautiful digital experiences with modern interfaces.",
    img: "https://images.unsplash.com/photo-1626785774573-4b799315345d?auto=format&fit=crop&w=800&q=80",
   },
  {
    id: 5,
    title: "Secure AI Payments",
    desc: "AI-driven payment protection built for the enterprise era.",
    img: "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=800&q=80",
  },
];

const ThumbnailGrid = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-200 p-8">
      <h1 className="text-4xl font-extrabold text-center text-gray-800 mb-10">
        🚀 Enterprise Marketing Thumbnails
      </h1>

      <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
        {thumbnails.map((thumb) => (
          <div
            key={thumb.id}
            className="bg-white rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-2 transition-all duration-300 overflow-hidden"
          >
            <div className="h-56 w-full overflow-hidden">
              <img
                src={thumb.img}
                alt={thumb.title}
                className="w-full h-full object-cover hover:scale-110 transition-transform duration-500"
              />
            </div>
            <div className="p-5">
              <h2 className="text-2xl font-semibold text-gray-800 mb-2">
                {thumb.title}
              </h2>
              <p className="text-gray-600 text-sm">{thumb.desc}</p>
              <button className="mt-4 inline-block bg-blue-600 text-white font-medium px-4 py-2 rounded-lg hover:bg-blue-700 transition-all duration-300">
                Learn More
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ThumbnailGrid;
