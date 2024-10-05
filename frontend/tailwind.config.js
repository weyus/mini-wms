const forms = require('@tailwindcss/forms');
const lineClamp = require('@tailwindcss/line-clamp');
const defaultTheme = require('tailwindcss/defaultTheme');

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    screens: {
      sm: '40rem', // 640px
      md: '48rem', // 768px
      lg: '64rem', // 1,024px
      xl: '80rem', // 1,280px
    },
    spacing: {
      0: '0px',
      px: '1px',
      0.5: '0.125rem', // 2px
      1: '0.25rem', // 4px
      1.5: '0.375rem', // 6px
      2: '0.5rem', // 8px
      2.5: '0.625rem', // 10px
      3: '0.75rem', // 12px
      3.5: '0.875rem', // 14px
      4: '1rem', // 16px
      4.5: '1.125rem', // 18px
      5: '1.25rem', // 20px
      6: '1.5rem', // 24px
      7: '1.75rem', // 28px
      8: '2rem', // 32px
      9: '2.25rem', // 36px
      10: '2.5rem', // 40px
      11: '2.75rem', // 44px
      12: '3rem', // 48px
      14: '3.5rem', // 56px
      16: '4rem', // 64px
      18: '4.5rem', // 72px
      20: '5rem', // 80px
      24: '6rem', // 96px
      32: '8rem', // 128px
      40: '10rem', // 160px
      48: '12rem', // 192px
      56: '14rem', // 224px
      64: '16rem', // 256px
      72: '18rem', // 288px
      80: '20rem', // 320px
    },
    colors: {
      transparent: 'transparent',
      white: '#FFFFFF',
      black: '#000000',
      gray: {
        25: '#FCFCFD',
        50: '#F9FAFB',
        100: '#F2F4F7',
        200: '#EAECF0',
        300: '#D0D5DD',
        400: '#98A2B3',
        500: '#667085',
        600: '#475467',
        700: '#344054',
        800: '#1D2939',
        900: '#101828',
      },
      ['gray-blue']: {
        25: '#FCFCFD',
        50: '#F8F9FC',
        100: '#EAECF5',
        200: '#D5D9EB',
        300: '#B3B8DB',
        400: '#717BBC',
        500: '#4E5BA6',
        600: '#3E4784',
        700: '#363F72',
        800: '#293056',
        900: '#101323',
      },
      ['gray-cool']: {
        25: '#FCFCFD',
        50: '#F9F9FB',
        100: '#EFF1F5',
        200: '#DCDFEA',
        300: '#B9C0D4',
        400: '#7D89B0',
        500: '#5D6B98',
        600: '#4A5578',
        700: '#404968',
        800: '#30374F',
        900: '#111322',
      },
      primary: {
        25: '#FCFAFF',
        50: '#F9F5FF',
        100: '#F4EBFF',
        200: '#E9D7FE',
        300: '#D6BBFB',
        400: '#B692F6',
        500: '#9E77ED',
        600: '#7F56D9',
        700: '#6941C6',
        800: '#53389E',
        900: '#42307D',
      },
      error: {
        25: '#FFFBFA',
        50: '#FEF3F2',
        100: '#FEE4E2',
        200: '#FECDCA',
        300: '#FDA29B',
        400: '#F97066',
        500: '#F04438',
        600: '#D92D20',
        700: '#B42318',
        800: '#912018',
        900: '#7A271A',
      },
      warning: {
        25: '#FFFCF5',
        50: '#FFFAEB',
        100: '#FEF0C7',
        200: '#FEDF89',
        300: '#FEC84B',
        400: '#FDB022',
        500: '#F79009',
        600: '#DC6803',
        700: '#B54708',
        800: '#93370D',
        900: '#7A2E0E',
      },
      success: {
        25: '#F6FEF9',
        50: '#ECFDF3',
        100: '#D1FADF',
        200: '#A6F4C5',
        300: '#6CE9A6',
        400: '#32D583',
        500: '#12B76A',
        600: '#039855',
        700: '#027A48',
        800: '#05603A',
        900: '#054F31',
      },
      green: {
        25: '#F6FEF9',
        50: '#EDFCF2',
        100: '#D3F8DF',
        200: '#AAF0C4',
        300: '#73E2A3',
        400: '#3CCB7F',
        500: '#16B364',
        600: '#099250',
        700: '#087443',
        800: '#095C37',
        900: '#084C2E',
      },
      teal: {
        25: '#F6FEFC',
        50: '#F0FDF9',
        100: '#CCFBEF',
        200: '#99F6E0',
        300: '#5FE9D0',
        400: '#2ED3B7',
        500: '#15B79E',
        600: '#0E9384',
        700: '#107569',
        800: '#125D56',
        900: '#134E48',
      },
      blue: {
        25: '#F5FAFF',
        50: '#EFF8FF',
        100: '#D1E9FF',
        200: '#B2DDFF',
        300: '#84CAFF',
        400: '#53B1FD',
        500: '#2E90FA',
        600: '#1570EF',
        700: '#175CD3',
        800: '#1849A9',
        900: '#194185',
      },
      'blue-dark': {
        25: '#F5F8FF',
        50: '#EFF4FF',
        100: '#D1E0FF',
        200: '#B2CCFF',
        300: '#84ADFF',
        400: '#528BFF',
        500: '#2970FF',
        600: '#155EEF',
        700: '#004EEB',
        800: '#0040C1',
        900: '#00359E',
      },
      'blue-light': {
        25: '#F5FAFF',
        50: '#EFF8FF',
        100: '#D1E9FF',
        200: '#B2DDFF',
        300: '#84CAFF',
        400: '#53B1FD',
        500: '#2E90FA',
        600: '#1570EF',
        700: '#175CD3',
        800: '#1849A9',
        900: '#194185',
      },
      indigo: {
        25: '#F5F8FF',
        50: '#EEF4FF',
        100: '#E0EAFF',
        200: '#C7D7FE',
        300: '#A4BCFD',
        400: '#8098F9',
        500: '#6172F3',
        600: '#444CE7',
        700: '#3538CD',
        800: '#2D31A6',
        900: '#2D3282',
      },
      orange: {
        25: '#FEFAF5',
        50: '#FEF6EE',
        100: '#FDEAD7',
        200: '#F9DBAF',
        300: '#F7B27A',
        400: '#F38744',
        500: '#EF6820',
        600: '#E04F16',
        700: '#B93815',
        800: '#932F19',
        900: '#772917',
      },
      purple: {
        25: '#FAFAFF',
        50: '#F4F3FF',
        100: '#EBE9FE',
        200: '#D9D6FE',
        300: '#BDB4FE',
        400: '#9B8AFB',
        500: '#7A5AF8',
        600: '#6938EF',
        700: '#5925DC',
        800: '#4A1FB8',
        900: '#3E1C96',
      },
      fuchsia: {
        25: '#FEFAFF',
        50: '#FDF4FF',
        100: '#FBE8FF',
        200: '#F6D0FE',
        300: '#EEAAFD',
        400: '#E478FA',
        500: '#D444F1',
        600: '#BA24D5',
        700: '#9F1AB1',
        800: '#821890',
        900: '#6F1877',
      },
      pink: {
        25: '#FEF6FB',
        50: '#FDF2FA',
        100: '#FCE7F6',
        200: '#FCCEEE',
        300: '#FAA7E0',
        400: '#F670C7',
        500: '#EE46BC',
        600: '#DD2590',
        700: '#C11574',
        800: '#9E165F',
        900: '#851651',
      },
      rose: {
        25: '#FFF5F6',
        50: '#FFF1F3',
        100: '#FFE4E8',
        200: '#FECDD6',
        300: '#FEA3B4',
        400: '#FD6F8E',
        500: '#F63D68',
        600: '#E31B54',
        700: '#C01048',
        800: '#A11043',
        900: '#89123E',
      },
      yellow: {
        25: '#FEFDF0',
        50: '#FEFBE8',
        100: '#FEF7C3',
        200: '#FEEE95',
        300: '#FDE272',
        400: '#FAC515',
        500: '#EAAA08',
        600: '#CA8504',
        700: '#A15C07',
        800: '#854A0E',
        900: '#713B12',
      },
      violet: {
        25: '#FBFAFF',
        50: '#F5F3FF',
        100: '#ECE9FE',
        200: '#DDD6FE',
        300: '#C3B5FD',
        400: '#A48AFB',
        500: '#875BF7',
        600: '#7839EE',
        700: '#6927DA',
        800: '#5720B7',
        900: '#491C96',
      },
      tavoro: {
        teal: '#15DBED',
        'light-blue': '#21A3FC',
        'medium-blue': '#0047AB',
        'dark-blue': '#1C2C43',
        orange: '#FFAD3A',
      },
    },
    boxShadow: {
      xs: '0px 1px 2px rgba(16, 24, 40, 0.05)',
      sm: '0px 1px 3px rgba(16, 24, 40, 0.1), 0px 1px 2px rgba(16, 24, 40, 0.06)',
      md: '0px 4px 8px -2px rgba(16, 24, 40, 0.1), 0px 2px 4px -2px rgba(16, 24, 40, 0.06)',
      lg: '0px 12px 16px -4px rgba(16, 24, 40, 0.08), 0px 4px 6px -2px rgba(16, 24, 40, 0.03)',
      xl: '0px 20px 24px -4px rgba(16, 24, 40, 0.08), 0px 8px 8px -4px rgba(16, 24, 40, 0.03)',
      '2xl': '0px 24px 48px -12px rgba(16, 24, 40, 0.18)',
      '3xl': '0px 32px 64px -12px rgba(16, 24, 40, 0.14)',
    },
    blur: {
      sm: '4px',
      md: '8px',
      lg: '12px',
      xl: '20px',
    },
    fontSize: {
      'display-2xl': [
        '4.5rem', // 72px
        {
          lineHeight: '5.625rem', // 90px
          letterSpacing: '-0.02em', // -2%
        },
      ],
      'display-xl': [
        '3.75rem', // 60px
        {
          lineHeight: '4.5rem', // 72px
          letterSpacing: '-0.02em', // -2%
        },
      ],
      'display-lg': [
        '3rem', // 48px
        {
          lineHeight: '3.75rem', // 60px
          letterSpacing: '-0.02em', // -2%
        },
      ],
      'display-md': [
        '2.25rem', // 36px
        {
          lineHeight: '2.75rem', // 44px
          letterSpacing: '-0.02em', // -2%
        },
      ],
      'display-sm': [
        '1.875rem', // 30px
        {
          lineHeight: '2.375rem', // 38px
        },
      ],
      'display-xs': [
        '1.5rem', // 24px
        {
          lineHeight: '2rem', // 32px
        },
      ],
      xl: [
        '1.25rem', // 20px
        {
          lineHeight: '1.875rem', // 30px
        },
      ],
      lg: [
        '1.125rem', // 18px
        {
          lineHeight: '1.75rem', // 28px
        },
      ],
      md: [
        '1rem', // 16px
        {
          lineHeight: '1.5rem', // 24px
        },
      ],
      sm: [
        '0.875rem', // 14px
        {
          lineHeight: '1.25rem', // 20px
        },
      ],
      xs: [
        '0.75rem', // 12px
        {
          lineHeight: '1.125rem', // 18px
        },
      ],
    },
    fontWeight: {
      regular: '400',
      medium: '500',
      semibold: '600',
      bold: '700',
    },
    extend: {
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans],
      },
      transitionTimingFunction: {
        radix: 'cubic-bezier(0.87, 0, 0.13, 1)',
      },
      keyframes: {
        slideDown: {
          from: { height: 0 },
          to: { height: 'var(--radix-collapsible-content-height)' },
        },
        slideUp: {
          from: { height: 'var(--radix-collapsible-content-height)' },
          to: { height: 0 },
        },
        ping5s: {
          '0%': {
            opacity: 50,
          },
          '75%, 100%': {
            transform: 'scale(2)',
            opacity: 0,
          },
        },
      },
      animation: {
        slideDown: 'slideDown 300ms cubic-bezier(0.87, 0, 0.13, 1)',
        slideUp: 'slideUp 300ms cubic-bezier(0.87, 0, 0.13, 1)',
        ping5s: 'ping5s 1s cubic-bezier(0.87, 0, 0.13, 1) 5',
      },
    },
  },
  plugins: [forms, lineClamp],
};
