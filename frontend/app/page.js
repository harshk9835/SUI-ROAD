
import Link from 'next/link'; 
import Head from 'next/head';

const items = [
  {
    item_name: 'Blockchain 101',
    price: '$19.99 or 50 SUI',
    image: 'https://images.unsplash.com/photo-1639322537228-f710d846310a?auto=format&fit=crop&q=80&w=1932&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    productLink: '/product/item1', // Replace with the actual product details page link
  },
  {
    item_name: 'Build a DEFI in 4 hourse',
    price: '$29.99 or 75 SUI',
    image: "https://images.unsplash.com/photo-1559445368-b8a993676d7a?auto=format&fit=crop&q=80&w=1931&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    productLink: '/product/item2', // Replace with the actual product details page link
  },
  {
    item_name: 'Ethereum Masterclass',
    price: '$39.99 or 100 SUI',
    image: 'https://unsplash.com/photos/vBCVcWUyvyM/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjk3ODU1NDI3fA&force=true&w=1920',
    productLink: '/product/item2', // Replace with the actual product details page link
  },
  // Add more items here
];

const HomePage = () => {
  return (
    <div>
      <nav className=" p-4">
          <div className="container mx-auto flex justify-between items-center">
            <h1 className="text-xl font-semibold">Suiroad</h1>
            <Link href="/login">
              <div className="bg-blue-500 text-white py-2 px-4 rounded-full text-lg font-semibold transition duration-300 hover:bg-orange-500 hover:text-white">
                Connect SUI Wallet
              </div>
            </Link>
          </div>
        </nav>
    <div className="bg-blue-500 text-white min-h-screen flex flex-col justify-center items-center">
      
      <header>
        
        <h1 className="text-4xl font-extrabold mb-4">Welcome to Suiroad</h1>
        <p className="text-lg mb-6">Sell What you know, keep what you earn</p>
        <a
          href="/shop" // Replace with the actual link to your shop page
          className="bg-white text-blue-500 py-2 px-4 rounded-full text-lg font-semibold transition duration-300 hover:bg-blue-500 hover:text-white"
        >
          Learn More 
        </a>
      </header>
      <section className="mt-12">
        <h2 className="text-2xl font-semibold mb-4">Featured Items</h2>
        <div className="grid grid-cols-3 gap-4">
          {items.map((item, index) => (
            <Link href={item.productLink} key={index}>
              <div className="bg-white p-4 rounded-lg cursor-pointer">
                <img
                  src={item.image}
                  alt={item.item_name}
                  className="w-full h-32 object-cover object-center mb-2"
                />
                <h3 className="text-lg text-gray-900 font-semibold">{item.item_name}</h3>
                <p className="text-gray-600">{item.price}</p>
              </div>
            </Link>
          ))}
        </div>
      </section>
    </div>
    </div>
  );
};

export default HomePage;
