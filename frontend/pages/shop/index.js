// pages/index.js

import Head from 'next/head';

const HomePage = () => {
  return (
    <div className="bg-blue-500 text-white min-h-screen flex flex-col justify-center items-center">
      <Head>
        <title>Suicommerce - Your Online Store</title>
      </Head>
      <header>
        <h1 className="text-4xl font-extrabold mb-4">Welcome to <span className="text-yellow-500">Suicommerce</span></h1>
        <p className="text-lg mb-6">Ecommerce Store Powered by Sui</p>
        <a
          href="/shop" // Replace with the actual link to your shop page
          className="bg-white text-blue-500 py-2 px-4 rounded-full text-lg font-semibold transition duration-300 hover:bg-blue-500 hover:text-white"
        >
          Start Shopping
        </a>
      </header>
      {/* Add more sections, features, and content here */}
    </div>
  );
};

export default HomePage;
