
async function fetchConfig() {
    try {
        const response = await fetch('/config.json')
            .then(function (response) {
                console.log(response)
                return response.json();
            })

        console.log(response)
        console.log(response['SERVER_URL'])
        return response
    } catch (e) {
        console.error("Unable to get config.json", e)
    }
}

// const serverUrl = "https://practice-tests-backend-manual.us-west-2.elasticbeanstalk.com"
// const stage = process.env.REACT_APP_STAGE??'local'
// let url = 'http://localhost:8080'

// if (stage !== 'local'){
//     const domain = CONFIG.ELASTIC_BEANSTALK_DOMAIN
//     const region = CONFIG.ENV.region
//     const cnamePrefixes = CONFIG.SERVER_URL_CNAME_PREFIXES as {[key: string]: string}
//     const cnamePrefix = cnamePrefixes[stage]
//     url = `https//${cnamePrefix}${CONFIG.ALIAS}.${region}.${domain}`
// }

// console.log(`${url}/user`)

// https://stackoverflow.com/questions/40981040/using-a-fetch-inside-another-fetch-in-javascript
const greetingAPI = {

    get() {

        return fetchConfig()
            .then((response) => {
                console.log(response['SERVER_URL'])
                const serverUserAPI = `${response['SERVER_URL']}/user`
                return fetch(serverUserAPI)
            }).then(response => {
                return response.json()
            }).then((response: Response) => {
                console.log(response)
            })

    }


    // get() {
    //     return fetch(`${url}/user`)
    //         .then((response: Response)=>{
    //             console.log(response)
    //             return response
    //         }).then((response: Response)=>{
    //             const a = response.json()
    //             return a
    //         }).then((a:Response)=>{
    //             console.log(a)
    //             // console.log(a.name)
    //         })
    // }
}

export { greetingAPI }